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

import { i18n } from '@kit.LocalizationKit';
import { LengthMetrics } from '@kit.ArkUI';
import bundleManager from '@ohos.bundle.bundleManager';
import bundleResource from '@ohos.bundle.bundleResourceManager';
import { bundleResourceManager } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { viewMgrPolicy, ViewType, DeviceHelper, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBSceneContainerSessionArray,
  SCBSceneSession
} from '@ohos/windowscene';
import { AppModel, StyleConstants } from '@ohos/launchercommon';
import { KeyCodeConstants } from '@ohos/commonconstants';
import mTools from '../utils/SystemTools';
import { PowerManagerEventType } from '../utils/Constants';
import { ShutdownViewConstant } from './ShutdownViewConstants';
import { RunningAppListState, RunningAppListStateArray } from './RunningAppListState';
import { SystemShutdownStyle } from './SystemShutdownStyle';
import { rpcShutdownPolicy } from '../policy/RpcShutdownPolicy';
import { BUNDLE_NAME_SETTINGS, pcShutdownDialogVMP } from './PcShutdownDialogVMP';

const TAG = 'ShutDownDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const MASTER_APPLICATION = 0;
const REFRESH_TIMER = 3;

@CustomDialog
export struct ShutDownDialog {
  public dialogController?: CustomDialogController;
  private titleHeight: number = 0;
  private tipHeight: number = 0;
  private cancelText: Resource = $r('app.string.common_cancel');
  private titleFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  private tipFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  private cancelFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary_activated');
  private warningFontColor: ResourceColor = $r('sys.color.ohos_id_color_warning');
  private cancelButtonBkgColor: ResourceColor = $r('sys.color.ohos_id_color_button_normal');
  private dividerColor: ResourceColor = $r('sys.color.ohos_id_color_list_separator');
  private warningButtonHover: boolean = false;
  private dialogTitle: Resource | undefined = undefined;
  @State dialogTip: Resource | undefined = undefined;
  private shutdownTimer: number | undefined = 60000;
  @Link dlgHeight: number; // 需要重新计算高度
  @ObjectLink runningAppList: RunningAppListStateArray;
  @Link isReboot: boolean;
  @Link isHibernate: boolean;
  @Link isModeChange: boolean;
  @State isLoading: boolean = true;
  @State listMaxHeight: number = SystemShutdownStyle.appListMaxHeight;
  @State warningText: Resource | undefined = undefined;
  @State countDownNumber: number = 1;

  doShutdownOrReboot() {
    viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
    if (rpcShutdownPolicy.getRpcView()) {
      try {
        rpcShutdownPolicy.rpcShutDownView('onClickRebootOrShutdown');
      } catch (e) {
        log.showError(`doShutdownOrReboot rpcShutDownView err, code: ${e?.code}, message: ${e?.message}`);
      }
      return;
    }
    log.showInfo(`is rebooting: ${this.isReboot} , is mode change:${this.isModeChange}, is hibernate:${this.isHibernate}`);
    if (this.isReboot) {
      HiSysEventUtil.reportPowerManagerEvent(PowerManagerEventType.haveRunningAppReboot);
      mTools.reboot();
    } else {
      if (this.isHibernate) {
        HiSysEventUtil.reportPowerManagerEvent(PowerManagerEventType.haveRunningAppHibernate);
        mTools.hibernate();
      } else {
        HiSysEventUtil.reportPowerManagerEvent(PowerManagerEventType.haveRunningAppShutdown);
        mTools.shutdown();
      }
    }
  }

  countDown() {
    this.shutdownTimer = setInterval(() => {
      if (this.countDownNumber % REFRESH_TIMER === 0) {
        this.changeRunningAppList();
      }
      this.countDownNumber++;
    }, SystemShutdownStyle.shutdownTimerConstant);
  }

  judgeWarningText() {
    if (this.isReboot) {
      this.warningText = $r('app.string.continue_restart');
    } else if (this.isModeChange) {
      this.warningText = $r('app.string.continue_mode_change');
    } else {
      this.warningText = $r('app.string.continue_shutdown');
    }
  }

  judgeDialogTitle() {
    if (this.isReboot) {
      this.dialogTitle = $r('app.string.confirm_restarting_dialog_title');
    } else if (this.isModeChange) {
      this.dialogTitle = $r('app.string.confirm_mode_change_dialog_title');
    } else {
      this.dialogTitle = $r('app.string.confirm_shutdown_dialog_title');
    }
  }

  judgeDialogTip() {
    if (this.isReboot) {
      this.dialogTip = $r('app.plural.confirm_reboot_tip', this.runningAppList.length, this.runningAppList.length);
    } else if (this.isModeChange) {
      this.dialogTip = $r('app.plural.confirm_mode_change_tip', this.runningAppList.length, this.runningAppList.length);
    } else {
      this.dialogTip = $r('app.plural.confirm_shutdown_tip', this.runningAppList.length, this.runningAppList.length);
    }
  }

  changeDlgHeight() {
    let height: number = 0;
    const appNum: number = this.runningAppList.length;
    if (appNum > 0 && appNum <= ShutdownViewConstant.maxAppNumWithoutScroll) {
      height = SystemShutdownStyle.confirmDlgDefaultHeight + appNum * SystemShutdownStyle.loadingSize;
    } else {
      height = SystemShutdownStyle.confirmDlgDefaultHeight + SystemShutdownStyle.appListMaxHeight;
    }
    this.dlgHeight = height + this.titleHeight + this.tipHeight;
    log.showInfo(`change dlgHeight: ${this.dlgHeight}`);
  }

  onTitleHeightChange(oldValue: Area, newValue: Area) {
    this.titleHeight = newValue.height as number;
    if (oldValue.height !== newValue.height) {
      this.dlgHeight += newValue.height as number - (oldValue.height as number);
    }
  }

  onTipsHeightChange(oldValue: Area, newValue: Area) {
    const tipHeight: number = newValue.height as number;
    let sub: number = tipHeight - SystemShutdownStyle.appListIconSize;
    this.listMaxHeight = SystemShutdownStyle.appListMaxHeight - sub;
    this.tipHeight = tipHeight;
    if (oldValue.height !== newValue.height) {
      this.dlgHeight += newValue.height as number - (oldValue.height as number);
    }
  }

  private changeRunningAppList(): void {
    log.showInfo('changeRunningAppList start');
    const tempRunningAppNameList = this.reGetRunningAppNameList();
    if (tempRunningAppNameList.length === 0) {
      log.showInfo('runningApp is 0');
      clearInterval(this.shutdownTimer);
      this.doShutdownOrReboot();
      viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
      return;
    }
    if (tempRunningAppNameList.length === this.runningAppList.length) {
      log.showInfo('runningApp number not change');
      return;
    }
    log.showInfo(`tempRunningAppNameList length: ${tempRunningAppNameList.length}, this.runningAppList length: ${this.runningAppList.length}`);
    for (let i = this.runningAppList.length - 1; i >= 0; i--) {
      if (tempRunningAppNameList.indexOf(this.runningAppList[i].appName) === -1) {
        log.showInfo(`app ${this.runningAppList[i].appName} is close`);
        this.runningAppList.splice(i, 1);
      }
    }
    if (this.runningAppList.length === 0) {
      log.showInfo('runningApp all close');
      clearInterval(this.shutdownTimer);
      this.doShutdownOrReboot();
      viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
      return;
    }
    this.judgeDialogTip();
    this.runningAppList[this.runningAppList.length - 1].hasDivider = false;
  }

  private dealWithContainerSessions(containerSessionList: SCBSceneContainerSessionArray, resList: string[]): string[] {
    log.showInfo('dealWithContainerSessions begin');
    if (!containerSessionList) {
      log.showInfo('dealWithContainerSessions containerSessionList is null!');
      return resList;
    }
    for (const containerSession of containerSessionList) {
      if (containerSession.isActive && containerSession.primarySession) {
        const primarySession: SCBSceneSession = containerSession.primarySession;
        if (!pcShutdownDialogVMP.isCurrentSessionRight(primarySession)) {
          continue;
        }
        const primaryBundleName: string = primarySession?.sceneInfo?.bundleName || '';
        if (rpcShutdownPolicy.getRpcView() && primaryBundleName === BUNDLE_NAME_SETTINGS) {
          log.showInfo(`${TAG} rpc not close settings`);
          continue;
        }
        if (resList.indexOf(primaryBundleName) === -1) {
          resList.push(primaryBundleName);
        }
      }
    }

    // 二分屏
    for (const containerSession of containerSessionList) {
      if (containerSession.isActive && containerSession.secondarySession) {
        const secondarySession: SCBSceneSession = containerSession.secondarySession;
        if (!pcShutdownDialogVMP.isCurrentSessionRight(secondarySession)) {
          continue;
        }
        const secondaryBundleName: string = secondarySession?.sceneInfo?.bundleName || '';
        if (rpcShutdownPolicy.getRpcView() && secondaryBundleName === BUNDLE_NAME_SETTINGS) {
          log.showInfo(`${TAG} rpc not close settings`);
          continue;
        }
        if (resList.indexOf(secondaryBundleName) === -1) {
          resList.push(secondaryBundleName);
        }
      }
    }
    return resList;
  }

  private getRunningAppBundleName(): Array<string> {
    log.showInfo('getRunningAppBundleName start');
    let resList: string[] = [];
    try {
      let containerSessionList =
        (DeviceHelper.is2In1DevicePadType() || DeviceHelper.is2In1DevicePcType()) ?
        SCBSceneSessionManager.getInstance().getContainerSessionList() :
        SCBSceneSessionManager.getInstance().getAllContainerSessionList();
      resList = this.dealWithContainerSessions(containerSessionList, resList);
      // 悬浮窗
      if (DeviceHelper.is2In1DevicePadType() || DeviceHelper.is2In1DevicePcType()) {
        log.showInfo('getRunningAppBundleName deal with floatingSessions');
        let floatingSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
        resList = this.dealWithContainerSessions(floatingSessionList, resList);
      }
    } catch (e) {
      log.showError(`getRunningAppBundleName failed! code: ${e?.code}, message: ${e?.message}`);
    }
    return resList;
  }

  private reGetRunningAppNameList(): string[] {
    log.showInfo('reGetRunningAppList start');
    const notifyRes = this.getRunningAppBundleName();
    const tempRunningAppName: string[] = [];
    for (const appBundleName of notifyRes) {
      try {
        this.normalInitRunningAppList(tempRunningAppName, appBundleName);
      } catch (err) {
        log.showError(`initRunningAppList failed! code: ${err?.code}, message: ${err?.message}`);
      }
    }
    return tempRunningAppName;
  }

  private normalInitRunningAppList(runningAppNameList: string[], bundleName: string): void {
    log.showInfo('normalInitRunningAppList start');
    try {
      let appInfoList = AppModel.getInstance().getAppInfoByBundleNameAndAppIndex(bundleName, MASTER_APPLICATION);
      if (appInfoList.length === 0) {
        log.showInfo(`get appInfoList length 0, bundleName: ${bundleName}`);
        return;
      }
      let appInfo = appInfoList[MASTER_APPLICATION];
      if (!appInfo) {
        log.showInfo(`getAppIconWithCache with invalid appInfo, bundleName: ${bundleName}`);
        return;
      }
      let flags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
      let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoSync(bundleName, flags);
      let sortedBundleLabel = bundleResource.getBundleResourceInfo(bundleInfo.name,
        bundleResource.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL |
        bundleResource.ResourceFlag.GET_RESOURCE_INFO_WITH_ICON);
      runningAppNameList.push(sortedBundleLabel.label)
      log.showInfo(`push app: ${sortedBundleLabel.label}`);
    } catch (e) {
      log.showError(`normalInitRunningAppList failed! code: ${e?.code}, message: ${e?.message}`);
    }
  }

  /**
   * 是否是合法状态栏类型
   *
   * @param statusBarType 状态栏类型
   * @returns 是否合法
   */
  private isValidStatusBar(statusBarType: number): boolean {
    return StatusBarType.isMacStyle(statusBarType) || StatusBarType.isWindowStyle(statusBarType);
  }

  @Styles
  shutdownButtonStyle() {
    .width(SystemShutdownStyle.confirmButtonWidth)
    .height(SystemShutdownStyle.buttonHeight)
    .borderRadius($r('sys.float.corner_radius_level4'))
  }

  @Builder
  AppListItem(listState: RunningAppListState) {
    Row() {
      Image(listState.icon)
        .width(SystemShutdownStyle.appListIconSize)
        .height(SystemShutdownStyle.appListIconSize)
        .margin({
          end: LengthMetrics.vp(SystemShutdownStyle.appListItemMarginRight),
          top: LengthMetrics.vp(SystemShutdownStyle.appListItemMarginTop),
          bottom: LengthMetrics.vp(SystemShutdownStyle.appListItemMarginBottom)
        })
        .interpolation(ImageInterpolation.Medium)
        .borderRadius(SystemShutdownStyle.appIconBorderRadius)
        .outline({
          width: SystemShutdownStyle.appOutlineWidth,
          color: SystemShutdownStyle.appOutlineColor,
          radius: {
            topLeft: SystemShutdownStyle.appIconBorderRadius,
            topRight: SystemShutdownStyle.appIconBorderRadius,
            bottomLeft: SystemShutdownStyle.appIconBorderRadius,
            bottomRight: SystemShutdownStyle.appIconBorderRadius
          }
        })
      Column() {
        if (listState.subName || listState.appName) {
          Text(listState.subName ? listState.subName : listState.appName)
            .width(SystemShutdownStyle.appListTitleWidth)
            .lineHeight(SystemShutdownStyle.appListNameLineHeight)
            .fontSize(SystemShutdownStyle.mediumFontSize)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(ShutdownViewConstant.confirmDlgTitleMaxLines)
            .margin({
              top: SystemShutdownStyle.appNameMarginTop,
              bottom: SystemShutdownStyle.appListNotSavingLineHeight
            })
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.ohos_fa_text_primary'))
            .direction(i18n.isRTL(i18n.System.getSystemLanguage()) ? Direction.Rtl : Direction.Ltr)
        }
        if (listState.hasDivider) {
          Divider()
            .strokeWidth('1px')
            .color(this.dividerColor)
            .width(SystemShutdownStyle.appListDividerWidth)
        }
      }
      .alignItems(HorizontalAlign.Start)
    }
    .height(SystemShutdownStyle.appListItemHeight)
    .margin({ left: SystemShutdownStyle.appListItemMargin, right: SystemShutdownStyle.appListItemMargin })
  }

  @Builder
  ButtonBuilder() {
    Row() {
      Button(this.cancelText, { type: ButtonType.Normal, stateEffect: true })
        .defaultFocus(true)
        .id(ShutdownViewConstant.cancelButtonId)
        .shutdownButtonStyle()
        .backgroundColor(this.cancelButtonBkgColor)
        .margin({ start: LengthMetrics.vp(SystemShutdownStyle.confirmButtonSpacingSize) })
        .fontColor(this.cancelFontColor)
        .onClick(() => {
          log.showInfo('click cancel');
          clearInterval(this.shutdownTimer);
          this.dialogController?.close();
          viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
          if (rpcShutdownPolicy.getRpcView()) {
            try {
              rpcShutdownPolicy.rpcShutDownView('onClickCancel');
            } catch (e) {
              log.showError(`cancel rpcShutDownView err, code: ${e?.code}, message: ${e?.message}`);
            }
          }
        })
      Button(this.warningText, { type: ButtonType.Normal, stateEffect: true })
        .shutdownButtonStyle()
        .backgroundColor(this.warningButtonHover ? $r('sys.color.ohos_id_color_hover') :
            $r('sys.color.ohos_id_color_button_normal'))
        .margin({ start: LengthMetrics.vp(SystemShutdownStyle.confirmButtonSpacingSize) })
        .fontColor(this.warningFontColor)
        .onHover((isHover: boolean) => {
          if (isHover) {
            this.warningButtonHover = true;
          } else {
            this.warningButtonHover = false;
          }
        })
        .onBlur(() => {
          focusControl.requestFocus(ShutdownViewConstant.cancelButtonId);
        })
        .onClick(() => {
          log.showInfo('click warning');
          clearInterval(this.shutdownTimer);
          this.doShutdownOrReboot();
          this.dialogController?.close();
          viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
        })
    }
    .width(StyleConstants.PERCENTAGE_100)
    .margin({ bottom: SystemShutdownStyle.buttonMarginBottom })
  }

  @Builder
  ApplicationListBuilder() {
    List() {
      ForEach(this.runningAppList, (list: RunningAppListState) => {
        ListItem() {
          this.AppListItem(list)
        }
      })
    }
    .width(StyleConstants.PERCENTAGE_100)
    .constraintSize({
      maxHeight: this.listMaxHeight
    })
    .margin({ top: SystemShutdownStyle.loadingTextMargin, bottom: SystemShutdownStyle.appListMarginBottom })
    .onAreaChange(() => {
      // 应用列表数据变动会触发子组件高度变动，此时需要在这里手动改变弹窗模糊背景的高度
      this.changeDlgHeight();
    })
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.countDown();
    this.judgeWarningText();
    this.judgeDialogTitle();
    this.judgeDialogTip();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Column() {
      Text(this.dialogTitle)
        .width(SystemShutdownStyle.confirmDlgDetailTipWidth)
        .lineHeight(SystemShutdownStyle.textLineHeight)
        .maxFontSize(SystemShutdownStyle.bigFontSize)
        .minFontSize(SystemShutdownStyle.mediumFontSize)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(ShutdownViewConstant.confirmDlgTitleMaxLines)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.titleFontColor)
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
        .textAlign(TextAlign.Center)
        .margin({
          left: SystemShutdownStyle.titleMarginLeft,
          right: SystemShutdownStyle.titleMarginRight,
          top: SystemShutdownStyle.titleMarginTop,
          bottom: SystemShutdownStyle.titleMarginBottom
        })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.onTitleHeightChange(oldValue, newValue);
        })
      Text(this.dialogTip)
        .width(SystemShutdownStyle.confirmDlgDetailTipWidth)
        .fontSize(SystemShutdownStyle.mediumFontSize)
        .fontColor(this.tipFontColor)
        .lineHeight(SystemShutdownStyle.textLineHeight)
        .margin({ left: SystemShutdownStyle.titleMarginLeft, right: SystemShutdownStyle.titleMarginRight })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.onTipsHeightChange(oldValue, newValue);
        })
      this.ApplicationListBuilder();
      this.ButtonBuilder();
    }
    .borderRadius(SystemShutdownStyle.confirmDialogBorderRadius)
    .height(this.dlgHeight)
    .width(SystemShutdownStyle.confirmDialogWidth)
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    .onKeyEvent((event?: KeyEvent) => {
      if (event?.keyCode === KeyCodeConstants.KEYCODE_ESCAPE && event?.type === KeyType.Up) {
        log.showInfo('close shutdown dialog due to esc');
        clearInterval(this.shutdownTimer);
        this.dialogController?.close();
        viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
        if (rpcShutdownPolicy.getRpcView()) {
          try {
            rpcShutdownPolicy.rpcShutDownView('onClickCancel');
          } catch (e) {
            log.showError(`cancel rpcShutDownView err, code: ${e?.code}, message: ${e?.message}`);
          }
        }
      }
    })
    .focusable(true)
  }
}