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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AppIconConfig } from '@ohos/launchercommon/Index';
import {
  StyleConstants,
  CommonConstants,
  DesktopMode,
  editModeManager,
  HiEditModeDataEnterType
} from '@ohos/launchercommon';
import { OuterIconCenterViewManager } from '@ohos/launchercommon/src/main/ets/manager/OuterIconCenterViewManager';
import { outerAddAppIconManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';

const TAG = 'OuterAddAppIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

const ADD_IMAGE_SCALE_SIZE: string = '51.8%';
const ADD_ICON_BG_OPACITY: number = 0.25;
const ANIMATION_DURATION_TIME: number = 250;

/**
 * 小折叠外屏桌面添加应用'+'号
 */
@Component
export struct OuterAddAppIcon {
  @StorageLink('isShowOuterAddAppIcon') isShowOuterAddAppIcon: boolean = false;
  @StorageLink('isDrag') isDrag: boolean = false;
  @StorageLink('isDeleteOuterApp') isDeleteOuterApp: boolean = false;
  @Link iconSize: number;
  @Link translateX: number;
  @Link translateY: number;
  private iconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;
  private appIconConfig: AppIconConfig = new AppIconConfig();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
  }

  private isVisible(): boolean {
    log.showInfo(`Add App icon isDrag=${this.isDrag}, isDeleteOuterApp=${this.isDeleteOuterApp}`);
    return !this.isDrag && !this.isDeleteOuterApp;
  }

  build() {
    if (this.isShowOuterAddAppIcon) {
      Column() {
        Stack() {
          Column()
            .backgroundColor($r('sys.color.ohos_id_color_background'))
            .opacity(ADD_ICON_BG_OPACITY)
            .borderRadius(this.iconRadius)
            .width(StyleConstants.PERCENTAGE_100)
            .height(StyleConstants.PERCENTAGE_100)
          Image(StyleConstants.DEFAULT_ADD_ICON_IMAGE)
            .id(`${TAG}_Image_AppAdd`)
            .draggable(false)
            .width(ADD_IMAGE_SCALE_SIZE)
            .height(ADD_IMAGE_SCALE_SIZE)
        }
        .id(`${TAG}_Outer_AppAdd`)
        .borderRadius(this.iconRadius)
        .width(this.iconSize)
        .height(this.iconSize)
        .alignRules(this.appIconConfig.alignRuleOption)
        .translate({ x: this.translateX, y: this.translateY })
        .transition(
          TransitionEffect.OPACITY.animation({ duration: ANIMATION_DURATION_TIME })
        )
        .visibility(this.isVisible() ? Visibility.Visible : Visibility.Hidden)
        .onClick(async () => {
          await editModeManager.changeDesktopMode(DesktopMode.EDIT_MODE, HiEditModeDataEnterType.ENTER_PINCH);
          OuterIconCenterViewManager.getInstance()
            .openOuterIconCenterView(CommonConstants.OUTER_EDIT_HALF_MODE_DEFAULT_HEIGHT);
          outerAddAppIconManager.outerAddAppIconReport();
          log.showInfo('outer add app icon open outer icon center.');
        })
      }
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
    }
  }
}