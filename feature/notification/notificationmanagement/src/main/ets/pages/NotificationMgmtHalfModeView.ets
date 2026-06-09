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

import { LogDomain, LogHelper,
  NotificationConfigEntity } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { BaseBindSheet } from './BaseBindSheet';
import HeadComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import { FontScaleState, fontScaleManager, DeviceHelper } from '@ohos/managementcomponent';
import { AppVersionInfo, NotificationMgmtViewData } from '../vm/NotificationMgmtViewData';
import display from '@ohos.display';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { NotificationMgmtHalfModeViewEvent } from '../vm/NotificationMgmtHalfModeViewEvent';
import { NotificationMgmtContentComponent } from './NotificationMgmtContentComponent';
import { ExtensionResult } from '../common/NotificationMgmtCommon';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import {
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { LengthMetrics } from '@ohos.arkui.node';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';

/* 页面标题 */
const pageTitle: Resource = $r('app.string.notifications');
const TAG = 'NotificationMgmtHalfMode_View';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const CONFIRM_BUTTON_ID = TAG + '_Button_Confirm';
const CONFIRM_TEXT_ID = TAG + '_Text_Confirm';

@Entry
@Component
export struct NotificationMgmtHalfModeView {
  private appInfo: ESObject = {};
  private userCanceled: boolean = true;
  private eventView: NotificationMgmtHalfModeViewEvent = new NotificationMgmtHalfModeViewEvent();
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @State viewData: NotificationMgmtViewData = new NotificationMgmtViewData();
  @State isShowPanel: boolean = true;
  @State appVersionInfo: AppVersionInfo = new AppVersionInfo();
  @State aiBarHeightByVp: number = 0;
  @State windowWidthByVp: number = 0;
  @State windowHeightByVp: number = 0;

  aboutToAppear(): void {
    log.showInfo('AboutToAppear.');
    this.initAppInfo();
    this.eventView.initModel(this.appInfo);
    this.eventView.initViewData(this.viewData);
    notificationSettingManager.subscribeChangeEvent(this.onConfigChange);
  }


  onConfigChange = (event: NotificationConfigEvent): void => {
    log.showInfo('OnConfigChanged. type: %{public}d', event.type);
    if (event.type === NotificationConfigEventType.UPDATE_RESOURCE) {
      this.refreshAppInfo();
      this.eventView.refreshSlots();
    }
  }

  private refreshAppInfo(): void {
    NotificationConfigEntity.queryByProps({ uid: Number(this.appInfo.appUid) }, { columns: ['label', 'versionName', 'icon'] })
      .then(entity => {
        this.appVersionInfo.appTitle = entity?.label ?? this.appInfo.appTitle;
        this.appVersionInfo.appVersion = entity?.versionName ?? this.appInfo.appVersion;
        this.appVersionInfo.appIcon = entity?.icon ?? this.appInfo.appIcon;
      });
  }


  aboutToDisappear(): void {
    log.showInfo('AboutToDisappear.');
  }

  private initAppInfo() {
    log.showInfo('LoadAppInfoFromLocalStorage.');
    const pageContext = PageStorages.getPageContext();
    if (pageContext?.bundleInfo) {
      this.appInfo = pageContext.bundleInfo;
      this.appVersionInfo.appTitle = this.appInfo.appTitle;
      this.appVersionInfo.appVersion = this.appInfo.appVersion;
      this.appVersionInfo.appIcon = this.appInfo.appIcon;
      log.showInfo('LoadAppInfoFromLocalStorage succeed.');
    } else {
      log.showWarn('LocalStorageParam or bundleInfo is none.');
    }
  }

  private isAIBarBottom(): boolean {
    return Math.min(this.windowWidthByVp, this.windowHeightByVp) < 600;
  }

  build() {
    Column() {
      BaseBindSheet({
        isShowPanel: this.isShowPanel,
        isShowClose: false,
        onPanelWillDisAppear: () => {
          setTimeout(() => {
            const operationType = this.userCanceled ? 0 : 1;
            this.eventView.reportHalfModeCloseOperate(operationType);
            PageStorages.getPageContext()?.session?.terminateSelfWithResult({ resultCode: ExtensionResult.SUCCESS });
          }, 200);
        }
      }) {
        this.buildHalfModePage()
      }
    }
    .width('100%')
    .height('100%')
    .onSizeChange(() => {
      ContextManager.loadWindow();
      this.aiBarHeightByVp = ContextManager.aiBarHeightByVp;
      this.windowWidthByVp = ContextManager.windowWidthByVp;
      this.windowHeightByVp = ContextManager.windowHeightByVp;
      log.showInfo(`aiBarHeightByVp: ${this.aiBarHeightByVp} windowWidthByVp: ${this.windowWidthByVp} windowHeightByVp: ${this.windowHeightByVp}`);
    })
  }

  @Builder
  buildHalfModePage() {
    Column() {
      this.buildPageTitleView()
      NotificationMgmtContentComponent({
        appInfo: this.appInfo,
        eventView: this.eventView,
        viewData: this.viewData,
        appVersionInfo: this.appVersionInfo
      })
      this.buildButton()
    }
    .backgroundColor($r('sys.color.ohos_id_color_panel_bg'))
    .padding({
      start: LengthMetrics.resource($r('app.float.ntf_half_mode_view_padding_start')),
      end: LengthMetrics.resource($r('app.float.ntf_half_mode_view_padding_end')),
      top: LengthMetrics.vp(8),
      bottom: LengthMetrics.vp(this.isAIBarBottom() ? this.aiBarHeightByVp : 0)
    })
  }

  @Builder
  buildPageTitleView() {
    HeadComponent({
      headName: pageTitle,
      navIcon: $r('app.media.ic_half_mode_nav'),
      hideBackButton: true,
      isShowCloseButton: true,
      onClosePanel: () => {
        this.isShowPanel = false;
      }
    })
      .margin({ end: LengthMetrics.resource($r('app.float.ntf_half_mode_view_margin_end')) })
  }

  @Builder
  buildButton() {
    Column() {
      Button(DeviceHelper.isPC() ? { type: ButtonType.Normal}
        : {type: ButtonType.Capsule}) {
        Text($r('app.string.confirm'))
          .id(CONFIRM_TEXT_ID)
          .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
          .fontSize(this.fontScaleState.getScaleSize($r('sys.float.ohos_id_text_size_sub_title2')))
          .fontWeight(FontWeight.Medium)
          .focusable(true)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
      }
      .id(CONFIRM_BUTTON_ID)
      .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
      .width('100%')
      .borderRadius(8)
      .constraintSize({
        maxWidth: 448,
        minHeight: 40
      })
      .padding({
        left: 16,
        right: 16,
        top: 8,
        bottom: 8
      })
      .onClick(() => {
        log.showInfo('click confirm.');
        this.eventView.onClickConfirm().then((res) => {
          this.isShowPanel = !res;
          this.userCanceled = !res;
        }).catch((err: Error) => {
          log.showError('onClickConfirm error: [%{public}s], [%{public}s]', err.name, err.message);
        });
      })
    }
    .margin({
      top: LengthMetrics.resource($r('app.float.ntf_half_mode_view_margin_top')),
      end: LengthMetrics.resource($r('app.float.ntf_half_mode_view_margin_end')),
      bottom: LengthMetrics.resource($r('app.float.ntf_half_mode_view_margin_bottom'))
    })
  }
}