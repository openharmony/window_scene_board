/**
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

import { componentUtils } from '@kit.ArkUI';
import {
  AppItemInfo,
  BigFolderStyleConfig,
  GridLayoutItemInfo,
  AppDataWrapper,
} from '@ohos/launchercommon';
import {
  AppIconCommonView,
  AppIconConfig,
  AppIconData,
  AppNameVm,
  FolderIconConfigUtil,
  openFolderAppBubbleLayout,
  openFolderHiddenIconLayout,
} from '@ohos/launchercommon/Index';
import { BigFolderViewModel } from '../viewmodel/BigFolderViewModel';
import { OpenFolderAppBubbleNodeManager } from './node/OpenFolderAppBubbleNodeManager';

const TAG = 'OpenFolderHiddenIcon';

// 不取0, 避免组件下树
const NEAR_OPACITY_ZERO = 0.0001;
const HALF_RATIO = 0.5;
const STACK_ICON_RATIO: number = 0.8;

@Component
export struct OpenFolderHiddenIcon {
  @State iconSize: number = 0;
  @State iconRadius: number = 0;
  @State iconData: AppIconData = new AppIconData();
  @State transX: number = 0;
  @State transY: number = 0;
  @State iconScale: number = 1;
  @State iconOpacity: number = NEAR_OPACITY_ZERO;
  @State nodeOpacity: number = 1;
  private showNameData?: AppNameVm;
  private item: GridLayoutItemInfo = new GridLayoutItemInfo();
  private isHidden: boolean = false;
  private showItem?: GridLayoutItemInfo;
  private folderAppBubbleNodeManager: OpenFolderAppBubbleNodeManager = OpenFolderAppBubbleNodeManager.getInstance();
  private folderStyleConfig: BigFolderStyleConfig = BigFolderViewModel.getInstance().getFolderStyleConfig();
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private onShowItemDisAppear?: (item: GridLayoutItemInfo) => void;

  private getPosition(): [number, number] {
    const info: componentUtils.ComponentInfo = this.getUIContext().getComponentUtils().getRectangleById(
      TAG + this.item.keyName ?? '');
    const openPosX = px2vp(info.screenOffset.x + info.size.width * HALF_RATIO);
    const openPosY = px2vp(info.screenOffset.y + info.size.height * HALF_RATIO);
    return [openPosX, openPosY];
  }

  private translateAnim(transX: number, transY: number): void {
    if (!this.isHidden || this.showItem) {
      const baseScale = this.folderStyleConfig.mFolderAppSize / this.folderStyleConfig.mOpenFolderAppSize;
      const scale = baseScale;
      this.transX = transX;
      this.transY = transY;
      this.iconScale = scale;
      if (!this.isHidden) {
        this.iconOpacity = 1;
      }
      if (this.showItem) {
        this.nodeOpacity = NEAR_OPACITY_ZERO;
      }
    }
  }

  private nameOpacityAnim(): void {
    if (this.showItem) {
      this.showNameData?.modifier.attribute?.opacity(0);
    }
  }
  aboutToAppear() {

    this.iconSize = this.folderStyleConfig.mOpenFolderAppSize;
    this.iconRadius = this.folderStyleConfig.mFolderIconRadius;
    if (!this.isHidden) {
      this.appIconConfig = FolderIconConfigUtil.getBigFolderImageConfig();
      this.appIconConfig.setAppDataOfTransactionController(new AppDataWrapper().setExtraId(TAG));
    }
    if (this.showItem) {
      this.showNameData = openFolderAppBubbleLayout.getNameData(this.showItem.keyName || '', this.showItem.bundleName);
    }
    if (!this.isHidden || this.showItem) {
      openFolderHiddenIconLayout.setLayoutData(this.item.keyName ?? this.item.bundleName, {
        getPosition: ():[number, number] => {
          return this.getPosition();
        },
        translateAnim: (transX: number, transY: number) => this.translateAnim(transX, transY),
        nameOpacityAnim: () => this.nameOpacityAnim(),
      });
    }
  }

  aboutToDisappear() {
    if (!this.isHidden || this.showItem) {
      openFolderHiddenIconLayout.deleteLayoutData(this.item.keyName ?? '');
    }
    if (this.showItem) {
      this.showNameData?.modifier.attribute?.opacity(1);
      this.onShowItemDisAppear?.(this.showItem);
    }
    // 清理内存
    this.isHidden = true;
    this.showItem = undefined;
    this.showNameData = undefined;
    this.onShowItemDisAppear = undefined;
  }

  build() {
    Stack() {
      if (!this.isHidden) {
        AppIconCommonView({
          item: this.item as AppItemInfo,
          iconSize: this.iconSize,
          iconRadius: this.iconRadius,
          appIconConfig: this.appIconConfig,
          iconData: this.iconData,
        })
          .opacity(this.iconOpacity)
      }

      if (this.showItem) {
        NodeContainer(this.folderAppBubbleNodeManager.getOrCreateNode(this.showItem.keyName as string, TAG))
          .id(`${TAG}_FolderAppItem_${this.showItem?.bundleName}`)
          .opacity(this.nodeOpacity)
      }
    }
    .height(this.folderStyleConfig.mOpenFolderAppSize)
    .width(this.folderStyleConfig.mOpenFolderAppSize)
    .id(TAG + this.item.keyName ?? '')
    .translate({ x: this.transX, y: this.transY })
    .scale({ x: this.iconScale, y: this.iconScale })
  }
}
