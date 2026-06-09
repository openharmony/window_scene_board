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

import { CheckEmptyUtils } from '@ohos/basicutils';
import {
  CommonConstants,
} from '@ohos/launchercommon';
import { AppBubbleParams, AppIconContainerModifier, DeskTopItemStyle } from '@ohos/launchercommon/Index';
import {
  BigFolderAppDefaultModifier
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/BigFolderAppDefaultModifier';
import DesktopAddDialogConstant from './DesktopAddDialogConstant';

export class DesktopAddBubbleViewModel {
  private static sInstance: DesktopAddBubbleViewModel;
  private params: AppBubbleParams = new AppBubbleParams;
  /**
   * 获取DesktopAddBubbleViewModel单例
   * @returns sInstance
   */
  static getInstance(): DesktopAddBubbleViewModel {
    if (DesktopAddBubbleViewModel.sInstance === undefined) {
      DesktopAddBubbleViewModel.sInstance = new DesktopAddBubbleViewModel();
    }
    return DesktopAddBubbleViewModel.sInstance;
  }

  public updateModifier(desktopStyle: DeskTopItemStyle, appIconContainerModifier: AppIconContainerModifier): void {
    appIconContainerModifier.attribute?.translate({
      x: CheckEmptyUtils.isEmpty(desktopStyle) ? 0 : desktopStyle.translateX,
      y: CheckEmptyUtils.isEmpty(desktopStyle) ? 0 : desktopStyle.translateY
    });
    appIconContainerModifier.attribute?.opacity(CheckEmptyUtils.isEmpty(desktopStyle) ?
      1 : desktopStyle.alpha);
    appIconContainerModifier.attribute?.scale(this.getScale(desktopStyle));
  }

  /**
   * 获取加号背景图层
   * @param appItemWidth 矩形图层的宽度
   * @returns BigFolderAppDefaultModifier
   */
  public getAddIconModifier(appItemWidth: number): BigFolderAppDefaultModifier {
    let modifier: BigFolderAppDefaultModifier = new BigFolderAppDefaultModifier();
    modifier.callback = (instance: CommonAttribute) => {
      instance
        .backgroundColor(DesktopAddDialogConstant.OPEN_FOLDER_ADD_ICON_BACKGROUND_COLOR)
        .draggable(false)
        .width(appItemWidth)
        .height(appItemWidth)
        .borderRadius(CommonConstants.DEFAULT_ICON_RADIUS)
        .backdropBlur(60)
    }
    return modifier;
  }

  /**
   * 获取Scale属性
   * @param desktopStyle: DeskTopItemStyle
   * @returns ScaleOptions
   */
  private getScale(desktopStyle: DeskTopItemStyle): ScaleOptions {
    if (CheckEmptyUtils.isEmpty(desktopStyle)) {
      return {
        x: 1,
        y: 1,
      }
    } else {
      return {
        x: desktopStyle.scale,
        y: desktopStyle.scale,
        centerX: desktopStyle.unLockAnimate ? desktopStyle.centerX : '50%',
        centerY: desktopStyle.unLockAnimate ? desktopStyle.centerY : '50%',
      }
    }
  }
}