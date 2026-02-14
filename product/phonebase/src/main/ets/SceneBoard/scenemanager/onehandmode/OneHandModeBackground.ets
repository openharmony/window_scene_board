/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SCBScreenProperty } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { common } from '@kit.AbilityKit';
import { OneHandModeManager } from './OneHandModeManager';
import lazy { SingleHandExitReason, SCBSingleHandController, SingleHandMode } from './SCBSingleHandController';
import { i18n } from '@kit.LocalizationKit';

const TAG = 'OneHandModeBackground';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const SETTINGS_RESPONSE_REGION_SIZE = 27;
const SETTINGS_RESPONSE_REGION_OFFSET = -1;
const SETTINGS_SIZE = 25;
const SETTINGS_HORIZONTAL_EDGE_DISTANCE = 20;
const SETTINGS_BOTTOM_DISTANCE = 30;
const ZERO_OFFSET = 0;
const ONE_HAND_MODE_STRING_BOTTOM_MARGIN = 12;
const ONE_HAND_MODE_EXIT_STRING_BOTTOM_MARGIN = 56;
const STRING_MAX_FONT_SCALE = 1.3;

@Component
export struct OneHandModeBackground {
  @ObjectLink screenProp: SCBScreenProperty;
  @State wordOpacity: number = 0;

  public setOpacity(opacity: number) {
    this.wordOpacity = opacity;
  }

  private checkIsInBackground(event: ClickEvent | undefined): boolean {
    if (!event) {
      return false;
    }
    if (SCBSingleHandController.getInstance().GetCurrentMode() === SingleHandMode.LEFT) {
      if (event.y > (px2vp(this.screenProp.height) * 0.25) && event.x < (px2vp(this.screenProp.width * 0.75))) {
        return false;
      }
    } else if (SCBSingleHandController.getInstance().GetCurrentMode() === SingleHandMode.RIGHT) {
      if (event.y > (px2vp(this.screenProp.height) * 0.25) && event.x > (px2vp(this.screenProp.width * 0.25))) {
        return false;
      }
    }
    return true;
  }

  aboutToAppear(): void {
    OneHandModeManager.getInstance().oneHandModeBackground = this;
  }

  build() {
    Stack() {
      Column() {
        Stack() {
          Stack() {
            Image($r('app.media.ic_public_settings'))
              .position({ right: ZERO_OFFSET, bottom: ZERO_OFFSET })
              .size({ width: SETTINGS_SIZE, height: SETTINGS_SIZE })
              .fillColor('#b3b6b7')
              .opacity(this.wordOpacity)
          }
          .size({ width: SETTINGS_SIZE, height: SETTINGS_SIZE })
          .position(i18n.isRTL(i18n.System.getSystemLanguage()) ?
            { left: SETTINGS_HORIZONTAL_EDGE_DISTANCE, bottom: SETTINGS_BOTTOM_DISTANCE } :
            { right: SETTINGS_HORIZONTAL_EDGE_DISTANCE, bottom: SETTINGS_BOTTOM_DISTANCE })
          .onClick(() => {
            const context = getContext(this) as common.UIAbilityContext;
            const want: Want = {
              bundleName: 'com.ohos.settings',
              abilityName: 'com.ohos.settings.MainAbility',
              uri: 'single_hand'
            };
            context.startAbility(want).catch((err: Error) => {
              log.showError(`startAbility settings failed, message:${err?.message}.`);
            })
            SCBSingleHandController.getInstance().exitSingleHand(SingleHandExitReason.CLICK_EMPTY);
          })
          .responseRegion({
            x: SETTINGS_RESPONSE_REGION_OFFSET,
            y: SETTINGS_RESPONSE_REGION_OFFSET,
            width: SETTINGS_RESPONSE_REGION_SIZE,
            height: SETTINGS_RESPONSE_REGION_SIZE
          })
          .accessibilityText($r('app.string.one_hand_mode_accessibility_str_entry_setting'))
        }
        .width('100%')
        .margin({ bottom: ZERO_OFFSET })

        Text($r('app.string.one_hand_mode'))
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor('#b3b6b7')
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .opacity(this.wordOpacity)
          .margin({ bottom: ONE_HAND_MODE_STRING_BOTTOM_MARGIN })
          .maxFontScale(STRING_MAX_FONT_SCALE)
        Text($r('app.string.one_hand_mode_exit'))
          .fontSize($r('sys.float.Subtitle_S'))
          .fontColor('#b3b6b7')
          .fontWeight(FontWeight.Regular)
          .textAlign(TextAlign.Center)
          .opacity(this.wordOpacity)
          .margin({ bottom: ONE_HAND_MODE_EXIT_STRING_BOTTOM_MARGIN })
          .maxFontScale(STRING_MAX_FONT_SCALE)
      }
      .width('100%')
      .height('25%')
      .position({ x: this.screenProp.left + 'px', y: this.screenProp.top + 'px' })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.End)
    }
    .onClick((event?: ClickEvent) => {
      if (this.checkIsInBackground(event)) {
        SCBSingleHandController.getInstance().exitSingleHand(SingleHandExitReason.CLICK_EMPTY);
      }
    })
    .width('100%')
    .height('100%')
    .position({ x: this.screenProp.left + 'px', y: this.screenProp.top + 'px' })
    .backgroundColor(Color.Black)
  }
}