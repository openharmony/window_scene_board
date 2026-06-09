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

import { LengthMetrics } from '@kit.ArkUI';

export enum NotificationSettingMenuType {
  OPEN_APP_NTF_MGMT = 'OpenAppNtfMgmt',
  CLOSE = 'Close',
  SILENCE = 'Silence',
  PIN_TOP = 'PinTop',
  OPEN_SETTING = 'OpenSetting',
}

@ObservedV2
export class NotificationSettingMenu {
  public type: NotificationSettingMenuType;
  public title: ResourceStr;
  public onClick: () => void;

  constructor(type: NotificationSettingMenuType, title: ResourceStr, onClick: () => void) {
    this.type = type;
    this.title = title;
    this.onClick = onClick;
  }
}

@ObservedV2
export class NotificationSettingDialogModel {
  /**
   * 是否展示弹窗
   */
  @Trace public isShowDialog: boolean = false;
  /**
   * 是否展示按钮
   */
  @Trace public isShowButton: boolean = false;
  /**
   * 弹窗标题
   */
  @Trace public dialogTitle: string = '';
  /**
   * 弹窗菜单列表
   */
  @Trace public readonly menus: NotificationSettingMenu[] = [];
  /**
   * 按钮离屏幕左边距离，单位vp
   */
  @Trace public buttonPositionLeft: number = 0;
  /**
   * 按钮离屏幕顶部距离，单位vp
   */
  @Trace public buttonPositionTop: number = 0;

  @Computed get buttonPosition(): LocalizedPosition {
    return {
      top: LengthMetrics.vp(this.buttonPositionTop),
      start: LengthMetrics.vp(this.buttonPositionLeft),
    };
  }
}