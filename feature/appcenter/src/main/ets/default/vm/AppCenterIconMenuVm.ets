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
import { AppIconMenuVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconMenuVm';
import { AppItemInfo, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FoldedDeviceAcViewModel } from '../folded/FoldedDeviceAcViewModel';
import AppGridLayoutCacheManager from '../common/cache/AppGridLayoutCacheManager';
import { AppLayoutInfo } from '../common/viewmodel/AppLayoutInfo';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'AppCenterIconMenuVm';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);


@Observed
export class AppCenterIconMenuVm extends AppIconMenuVm {
  private item: AppItemInfo | null = null;
  /**
   * 长按菜单预览图动效
   */
  protected menuPreviewAnimOptions: ContextMenuAnimationOptions | undefined = {
    scale: [StyleConstants.MENU_NO_ANIMATION, StyleConstants.MENU_NO_ANIMATION],
    transition: this.isHiddenEffect ? TransitionEffect.asymmetric(
      TransitionEffect.opacity(0),
      TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
  }

  public getMenuPlacement(isLongPressMenu?: boolean): Placement | undefined {
    let appList: AppLayoutInfo[] = AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemList(false);
    let appItem: AppItemInfo | undefined =
      AppGridLayoutCacheManager.getInstance().lookForApp(appList, this.item?.bundleName ?? '', this.item?.appIndex);
    if (isLongPressMenu && (FoldedDeviceAcViewModel.getInstance().isFoldedDevice() &&
      (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()))) {
      if (appItem?.page !== undefined && appItem?.row !== undefined && (appItem?.page % 2 === 1) &&
        (appItem?.row > 0)) {
        return Placement.TopLeft;
      } else {
        return Placement.BottomLeft;
      }
    }
    if (isLongPressMenu || (FoldedDeviceAcViewModel.getInstance().isFoldedDevice() &&
      (FoldedDeviceAcViewModel.getInstance().isHalfFolded()))) {
      if (appItem?.row !== undefined && appItem?.row > 1) {
        return Placement.TopLeft;
      } else {
        log.showInfo('The row of item is smaller than 2 or the item is undefined.');
        return Placement.BottomLeft;
      }
    }
    return undefined;
  }

  public getMenuTransition(isLongPressMenu?: boolean): TransitionEffect | undefined {
    if (isLongPressMenu) {
      return TransitionEffect.asymmetric(
        TransitionEffect.opacity(0),
        TransitionEffect.IDENTITY.animation({ duration: 0 }));
    }
    return this.menuTransition;
  }

  public setAppItemInfo(item: AppItemInfo): void {
    this.item = item;
  }
}