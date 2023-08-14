class HPermissibleRange < ActiveHash::Base
  self.data = [
    { id: 1, name: '一般公開' },
    { id: 2, name: 'メンバーにのみ公開' },
    { id: 3, name: 'プライベート公開' }
  ]
  end