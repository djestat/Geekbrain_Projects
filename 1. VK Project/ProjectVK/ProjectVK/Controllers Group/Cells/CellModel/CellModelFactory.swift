//
//  CellModelFactory.swift
//  ProjectVK
//
//  Created by Igor on 10.11.2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

final class CellModelFactory {
    
    func constructGroupViewModels(from groups: [REALMGroup]) -> [GroupCellModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from group: REALMGroup) -> GroupCellModel {
        let id = group.id
        let groupName = group.name
        let groupPhoto = group.image
        let isMember = group.isMember
        return GroupCellModel(id: id, groupName: groupName, groupPhoto: groupPhoto, isMember: isMember)
    }
}
