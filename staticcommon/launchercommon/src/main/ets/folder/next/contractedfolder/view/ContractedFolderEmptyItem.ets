/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { AppIconData } from '../../../../launchericon/viewmodel/AppIconData';
import { StyleConstants } from '../../../../TsIndex';
import { folderIconDataMgr } from '../viewmodel/manager/ContractedFolderIconDataManager';

const TAG = 'ContractedFolderEmptyItem';

/**
 * 文件夹关闭态堆叠空白图标
 */
@Component
export struct ContractedFolderEmptyItem {
  @State appData: AppIconData = new AppIconData();
  @Require @Prop iconSize: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Require @Prop iconRadius: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Require @Prop @Watch('onResizeModeChange') editFolderMode: boolean = false;
  @Require public index: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Require public maskBgColor: string = '#00000000';

  aboutToAppear(): void {
    this.appData.isShowMask = true;
    this.appData.maskOpacity = 1;
    this.appData.maskBgColor = this.maskBgColor;
    this.appData.iconOpacity = 0;
    this.appData.isEmpty = true;
    if (this.editFolderMode) {
      folderIconDataMgr.setIconData(String(this.index), this.appData);
    }
  }

  onResizeModeChange(): void {
    if (this.editFolderMode) {
      folderIconDataMgr.setIconData(String(this.index), this.appData);
    }
  }

  build() {
    Stack() {
      Column()
        .backgroundColor(Color.White)
        .borderRadius(this.iconRadius)
        .opacity(0.5)
        .width(this.iconSize)
        .height(this.iconSize)
        .transition(TransitionEffect.opacity(StyleConstants.DEFAULT_FOLDER_HIDDEN_VALUE))
        .id(`${TAG}_Column_Empty_${this.index}`)

      Column()
        .width(this.iconSize)
        .height(this.iconSize)
        .backgroundColor(this.appData.maskBgColor)
        .opacity(this.appData.maskOpacity)
        .borderRadius(this.iconRadius)
        .enabled(false)
        .id(`${TAG}_Column_Empty_Mask_${this.index}`)
    }
    .translate({ x: this.appData.transX, y: this.appData.transY })
    .offset({ x: this.appData.offsetX, y: this.appData.offsetY })
    .opacity(this.appData.iconOpacity)
    .scale({ x: this.appData.iconScale, y: this.appData.iconScale })
    .borderRadius(this.iconRadius)
  }
}