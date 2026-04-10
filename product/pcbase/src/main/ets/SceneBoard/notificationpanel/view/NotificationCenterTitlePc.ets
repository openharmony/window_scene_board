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
  NotificationSysEventReporter
} from '@ohos/systemuicommon';

import {
  DomainName,
  LogDomain,
  LogHelper,
  Trace,
  TraceUtil,
} from '@ohos/basicutils';
import { HiDfxEventUtil, ResourceManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { HoverConstants } from '@ohos/commonconstants';
import { NotificationConfig } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConfig';
import { NotificationConstants } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConstants';
import { NtfListVm, NtfCanClear } from '@ohos/notificationcomponent/src/main/ets/model/NtfListVm';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import {
  ColorModeViewData,
  ColorModeViewModel
} from '@ohos/systemuicommon/Index';
import { NtfAnimVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfAnimVM';
import Constants from '../../../common/constants/StatusBarPanelConstants';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = NotificationConstants.NTF_LOG_PREFIX + 'PcNotificationCenterTitle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_CLEAR = TAG + '_Image_clear';
const COMPONENT_ID_NTF_CENTER_TITLE = TAG + '_Text_ntfCenterTitle';

const LEFT_PADDING = 24;
const RIGHT_PADDING = 16;

/**
 * PC面板顶部 通知中心
 */
@Component
export struct NotificationCenterTitlePc {
  /**
   * VM
   */
  private ntfListVM?: NtfListVm;

  /**
   * 动效vm
   */
  ntfAnimVM: NtfAnimVM | undefined = undefined;

  /**
   * 是否显示全部清除按钮
   */
  @Consume isShowClearButton: boolean;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  build() {
    Row() {
      // 通知中心
      Text($r('app.string.ntf_center_title'))
        .id(COMPONENT_ID_NTF_CENTER_TITLE)
        .fontSize($r('app.float.ntf_center_title_font_size'))
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .fontWeight(FontWeight.Bold)
        .height('100%')
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .ellipsisMode(EllipsisMode.END)
        .maxLines(1)
        .width($r('app.float.ntf_center_title_width'))
      Blank()

      Button({ type: ButtonType.Normal }) {
        this.buildSettingButton()
      }
      .id(Constants.COMPONENT_ID_NTF_MANAGER)
      .backgroundColor(Color.Transparent)
      .borderRadius($r('app.float.ntf_center_btn_hover_size'))
      .onClick(() => {
        this.ntfListVM?.startNtfManagerMain();
        HiDfxEventUtil.reportNtfPanelJumpNtfManagement();
        NotificationSysEventReporter.notificationPanelSetting({
          TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`
        });
      })

      Button({ type: ButtonType.Normal }) {
        this.buildClearButton()
      }
      .margin({ start: LengthMetrics.resource($r('app.float.Notification_center_icon_space')) })
      .focusable(this.isShowClearButton)
      .backgroundColor(Color.Transparent)
      .borderRadius($r('app.float.ntf_center_btn_hover_size'))
      .onClick(() => {
        log.showInfo('ClearNtAni start');
        TraceUtil.startTrace(DomainName.NC, Trace.CORE_METHOD_DELETE_NOTIFICATION);
        this.ntfListVM?.clearAllNtf(this.ntfAnimVM?.getClearAllDuration() ?? 0);
        HiDfxEventUtil.reportDeleteAllNotification();
        const clearCount: NtfCanClear = this.ntfListVM?.getAllCanClearCount() || {
          unknownNtfCount: 0,
          socialNtfCount: 0,
          serviceNtfCount: 0,
          contentNtfCount: 0,
          allNtfCount: 0
        };
        NotificationSysEventReporter.notificationPanelClear({
          TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
          UNKNOWN_DELETED_NUMBER: clearCount.unknownNtfCount,
          SOCIAL_DELETED_NUMBER: clearCount.socialNtfCount,
          SERVICE_DELETED_NUMBER: clearCount.serviceNtfCount,
          CONTENT_DELETED_NUMBER: clearCount.contentNtfCount,
          DELETED_NUMBER: clearCount.allNtfCount
        });
      })
      .hoverEffect(this.isShowClearButton ? HoverEffect.Auto : HoverEffect.None)
    }
    .width('100%')
    .height($r('app.float.ntf_center_header_pc_height'))
    .padding({
      start: LengthMetrics.vp(LEFT_PADDING),
      end: LengthMetrics.vp(RIGHT_PADDING)
    })
    .alignItems(VerticalAlign.Center)
  }

  /**
   * 通知管理按钮
   */
  @Builder
  buildSettingButton() {
    Column() {
      Image($r('app.media.ic_ntf_btn_manager'))
        .objectFit(ImageFit.Contain)
        .fillColor(this.colorModeViewData.commonIconOffColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .width($r('app.float.ntf_action_send_icon_size'))
        .height($r('app.float.ntf_action_send_icon_size'))
        .draggable(false)
        .edgeAntialiasing(0.5)
    }
    .width($r('app.float.ic_ntf_btn_manager_size'))
    .height($r('app.float.ic_ntf_btn_manager_size'))
    .borderRadius($r('app.float.ic_ntf_btn_manager_border_radius'))
    .justifyContent(FlexAlign.Center)
    .margin(1)
  }

  /**
   * 一键清理按钮
   */
  @Builder
  buildClearButton() {
    Column() {
      // 全部清除按钮
      SymbolGlyph($r('sys.symbol.trash'))
        .id(COMPONENT_ID_CLEAR)
        .fontColor([this.colorModeViewData.commonIconOffColor])
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .fontSize($r('app.float.ntf_action_send_icon_size'))
        .draggable(false)
        .focusable(this.isShowClearButton)
        .opacity(this.isShowClearButton ?
          NotificationConfig.NTF_CLEAR_ICON_ALPHA : NotificationConfig.NTF_EMPTY_CLEAR_ICON_ALPHA)
    }
    .id('CLEAN_ICON')
    .width($r('app.float.ic_ntf_btn_manager_size'))
    .height($r('app.float.ic_ntf_btn_manager_size'))
    .borderRadius($r('app.float.ic_ntf_btn_manager_border_radius'))
    .justifyContent(FlexAlign.Center)
    .margin(1)
  }
}
