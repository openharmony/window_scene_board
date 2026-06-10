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

import { NotificationAction } from '@ohos/systemuicommon';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import { NtfActionVM } from '../vm/GlassNtfActionVM';
import { GlassLayoutColor } from '../../common/constants/GlassLayoutConstants';
import { GlassBannerLayoutStyle } from '../view/GlassBannerStyle';
import GlassNtfConstant from '../common/GlassNtfConstant';
import { GlassAppWhiteListManager } from './../../common/manager/GlassAppWhiteListManager';
import { GlassShowToastOptions, GlassToastManager } from '../../toast/manager/GlassToastManager';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NtfToastCommon } from './../../common/constants/GlassLayoutConstants';

const TAG = 'NotificationActionView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassNtfActionView {
  @Consume ntf: NotificationEntry | null;
  @State inputActionIndex: number = -1;
  @State ntfActionList: NotificationAction[] = [];
  private actionVM: NtfActionVM = new NtfActionVM();

  aboutToAppear(): void {
    // 初始化通知数据
    this.refreshNtfData();
    // 注册数据刷新
    if (this.ntf) {
      this.ntf.registerDataUpdateListener(this);
    }
    this.actionVM.init(this);
  }

  aboutToDisappear(): void {
    if (this.ntf) {
      this.ntf.unregisterDataUpdateListener(this);
    }
    this.actionVM.onDestroy();
  }

  /**
   * 获取通知数据
   * ActionCallback
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry | null {
    return this.ntf;
  }

  /**
   * 获取通知面板类型
   * ActionCallback
   *
   * @return 通知面板类型
   */
  getNtfType(): number {
    return NotificationType.TYPE_PHONE_DROPDOWN;
  }

  /**
   * 通知数据变化回调
   * NtfDataUpdateListener
   *
   * @param newEntry 新通知对象
   */
  onNtfDataUpdate(newEntry: NotificationEntry): void {
    this.ntf = newEntry;
    // 刷新通知数据
    this.refreshNtfData();
  }

  private refreshNtfData(): void {
    // action按钮列表，最多显示2个按钮
    if (!this.ntf) {
      return;
    }
    let size = Math.min(this.ntf.actionButtons.length, GlassNtfConstant.BUTTON_MAX_SHOW_SIZE);
    this.ntfActionList = this.ntf.actionButtons.slice(0, size);
  }

  /**
   * 是否正在输入
   */
  private isInputting(): boolean {
    return this.inputActionIndex !== -1;
  }

  private onClickEvent(action: NotificationAction, index: number): void {
    if (!CommonUtils.isEmpty(action.userInputKey)) {
      this.inputActionIndex = index;
    } else {
      log.info(`enter startWantAgent`);
      this.actionVM.startNtfAction(action, true);
    }
  }

  build() {
    Row() {
      // 回复input显示
      if (this.isInputting()) {
      } else { // 按钮显示
        ForEach(this.ntfActionList, (action: NotificationAction, index: number) => {
          ActionButton({
            action: action,
            onClickEvent: () => {
              if (!this.ntf?.creatorBundleName) {
                return;
              }
              if (action.actionTitle ===
              getContext().resourceManager.getStringSync($r('app.string.action_button_reply'))) {
                let appInfo: boolean =
                  GlassAppWhiteListManager.getInstance().isWhiteListApp(this.ntf.creatorBundleName);
                if (!appInfo) {
                  let options: GlassShowToastOptions = {
                    message: NtfToastCommon.CAN_NOT_OPEN_MSG,
                    bottom: NtfToastCommon.TOAST_BOTTOM,
                    duration: NtfToastCommon.TOAST_DURATION,
                    width: NtfToastCommon.CAN_NOT_OPEN_MSG_WID
                  }
                  GlassToastManager.getInstance().showToast(options);
                  return;
                }
              }
              this.onClickEvent(action, index)
            },
          })
        }, (action: NotificationAction) => `${action.actionTitle}_${action.getUpdateCount()}`)
      }
    }
    .justifyContent(FlexAlign.Start)
  }
}

/**
 * action按钮
 */
@Component
struct ActionButton {
  private action?: NotificationAction;
  private onClickEvent: (() => void) = () => {
  };

  build() {
    Stack() {
      Text(this.action?.actionTitle)
        .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
        .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_700)
        .fontColor(GlassLayoutColor.TEXT_TITLE_COLOR)
        .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_33)
    }
    .onClick(this.onClickEvent)
    .margin(GlassBannerLayoutStyle.ACTION_BUTTON_MARGIN)
  }
}