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
        let groupName = String(group.name)
        let groupPhoto = String(group.image)
        return GroupCellModel(groupName: groupName, groupPhoto: groupPhoto)
    }
}
