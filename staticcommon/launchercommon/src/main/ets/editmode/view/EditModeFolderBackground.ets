/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  ContractedFolderViewObserver
} from '../../folder/next/contractedfolder/viewmodel/layout/ContractedFolderViewObserver';
import { EditModeConstants } from '../../TsIndex';
import { EditModeFolderViewData } from '../data/EditModeFolderViewData';
import { editModeManager } from '../model/EditModeManager';

const TAG: string = 'EditModeBackground';
/**
 * 编辑模式文件夹背板组件
 */
@Component
export default struct EditModeFolderBackground {
  private folderId?: string = '';
  @State editModeFolderViewData: EditModeFolderViewData = editModeManager.getEditModeFolderViewData();
  @State private layoutOsr: ContractedFolderViewObserver = new ContractedFolderViewObserver();

  build() {
    Column() {
    }
    .opacity(this.editModeFolderViewData.getFolderBackgroundOpacity())
    // 编辑模式文件夹背板透明度变化动效，只对opacity生效，若需新增属性，请写在animation属性下方
    .animation({ curve: EditModeConstants.CHANGE_DESKMODE_CURVE })
    .borderRadius(this.layoutOsr.resizeOsr.backgroundRadius)
    .width(this.layoutOsr.folderOsr.folderWidth * this.layoutOsr.resizeOsr.scaleX)
    .height(this.layoutOsr.folderOsr.folderHeight * this.layoutOsr.resizeOsr.scaleY)
    .scale({ x: this.layoutOsr.folderBgOsr.scaleX, y: this.layoutOsr.folderBgOsr.scaleY })
    .translate({ x: this.layoutOsr.folderBgOsr.transX, y: this.layoutOsr.folderBgOsr.transY })
    .backgroundColor(this.editModeFolderViewData.getFolderBackgroundColor())
    .id(`${TAG}${this.folderId}`)
    .alignRules(this.layoutOsr.resizeOsr.alignRules)
  }
}