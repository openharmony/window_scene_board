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
import { screenLockSysFloatTipControl } from '../manager/SysFloatTipController';
import { FontScaleState } from '@ohos/systemuicommon/src/main/ets/TsIndex';

const TAG = 'SysFloatTipDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SYS_TIP_DIALOG_RADIUS = 36;
const SYS_TIP_DIALOG_VERTICAL_MARGIN = 8;
const SYS_TIP_DIALOG_HORIZON_MARGIN = 16;

/**
 * 仿系统悬浮提示框（层级高于System Float window时使用）
 *
 * @since 2023-12-26
 */
@CustomDialog
export default struct SysFloatTipDialog {
  @State tipMessage: string | undefined = undefined;

  @State tipMarginBottom: number = 0;

  @State isShowing: boolean = false;

  @Prop componentId: string;

  /**
   * 必写，组件自动赋值
   */
  private dialogController?: CustomDialogController;

  public setSysFloatTipDialogVisible(isShowing: boolean) {
    this.isShowing = isShowing;
  }

  public setTipMessage(tipMessage: string) {
    this.tipMessage = tipMessage;
  }

  public setTipMarginBottom(tipMarginBottom: number) {
    this.tipMarginBottom = tipMarginBottom;
  }

  public getComponentId(): string {
    return this.componentId;
  }

  aboutToAppear() {
    screenLockSysFloatTipControl.registerCallback(this);
  }

  aboutToDisappear() {
    screenLockSysFloatTipControl.unRegisterCallback(this);
  }

  build() {
    Column() {
      Text(this.tipMessage)
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
        .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .maxFontScale(FontScaleState.tipMaxScale)
        .margin({
          left: SYS_TIP_DIALOG_HORIZON_MARGIN,
          right: SYS_TIP_DIALOG_HORIZON_MARGIN,
          top: SYS_TIP_DIALOG_VERTICAL_MARGIN,
          bottom: SYS_TIP_DIALOG_VERTICAL_MARGIN
        })
    }
    .id(TAG + '_' + this.componentId)
    .backgroundColor($r('sys.color.ohos_id_color_help_tip_bg'))
    .margin({
      bottom: this.tipMarginBottom
    })
    .borderRadius(SYS_TIP_DIALOG_RADIUS)
    .visibility(this.isShowing ? Visibility.Visible : Visibility.None)
    .hitTestBehavior(HitTestMode.None)
  }
}