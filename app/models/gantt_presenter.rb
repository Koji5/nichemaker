class GanttPresenter

  def initialize(niche_id)
    @gantts = NicheProgressTask.joins(:niche_progress_group).left_joins(:progress_rates)
    .joins(
      "LEFT JOIN (
        SELECT niche_progress_group_id, MIN(start) as earliest_start
        FROM niche_progress_tasks
        GROUP BY niche_progress_group_id
      ) AS group_starts ON niche_progress_groups.id = group_starts.niche_progress_group_id"
    )
    .select(
      "niche_progress_groups.niche_id as niche_id",
      "niche_progress_groups.id as group_id",
      "niche_progress_tasks.id as task_id",
      "niche_progress_groups.name as group_name",
      "niche_progress_tasks.name as task_name",
      "niche_progress_tasks.start as start",
      "niche_progress_tasks.end as end",
      "COALESCE(MAX(progress_rates.rate), 0) as progress",
      "group_starts.earliest_start as earliest_group_start"
    )
    .where(niche_progress_groups: { niche_id: niche_id })
    .group('niche_progress_groups.niche_id', 'niche_progress_tasks.id', 'group_starts.earliest_start')
    .order('group_starts.earliest_start', 'niche_progress_tasks.start', 'niche_progress_tasks.name')
  end

  def gantts_to_hashes
    prev_group_id = ''
    prev_gantt_id = nil  # 前回のganttのIDを保持する変数
  
    result = @gantts.map do |gantt|
      current_gantt_id = gantt.niche_id.to_s + '_' + gantt.group_id.to_s + '_' + gantt.task_id.to_s
      mapped_gantt = {
        id: current_gantt_id,
        name: gantt.group_name + ' - ' + gantt.task_name,
        start: gantt.start.strftime('%Y-%m-%d'),
        end: gantt.end.strftime('%Y-%m-%d'),
        progress: gantt.progress,
        dependencies: (gantt.group_id == prev_group_id && prev_gantt_id) ? prev_gantt_id : '' # ここを修正
      }
  
      # 現在のganttのgroup_idとIDを更新
      prev_group_id = gantt.group_id
      prev_gantt_id = current_gantt_id
      
      mapped_gantt
    end
    
    result
  end
end