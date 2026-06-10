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
import { ClickNotificationErrorCode, ClickNotificationMaintenance } from '../maintenance/ClickNotificationMaintenance';
import { NotificationConfigBaseManager } from '../manager/NotificationConfigBaseManager';
import { NotificationBase } from '../model/NotificationBase';
import { INotificationSilenceVm } from '../notification/interface/INotificationSilenceVm';
import { NotificationVmInjector } from '../notification/NotificationVmInjector';
import { NotificationBaseVm } from '../notification/vm/NotificationBaseVm';
import { NotificationSysEventReporter } from '../utils/NotificationSysEventReporter';
import { DropdownVm } from './DropdownVm';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { ResUtils } from '@ohos/windowscene';
import { AnimationBase } from '../animation/AnimationBase';
import { curves } from '@kit.ArkUI';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'NotificationSilenceVm';
const AIMATION_CURVE = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

/**
 * 通知静默ViewModel
 */
@ObservedV2
export class NotificationSilenceVm extends NotificationBaseVm implements INotificationSilenceVm {
  @Trace public isSilenceDialogShow = false;
  @Trace public dialogTitle = '';
  @Trace public isShowFlag = false;
  private manager?: NotificationConfigBaseManager;
  public ntf?: NotificationBase;
  private anim: AnimationBase = new AnimationBase(AnimationBase.NAMES.NTF_DIALOG_ANIMATION, true);
  private dropdownVm = DropdownVm.instance;

  /**
   * 当前静默的应用名
   */
  public silentAppLabel: string = '';
  private controller?: CustomDialogController;

  constructor(vmInjector: NotificationVmInjector) {
    super(vmInjector);
  }

  init(manager: NotificationConfigBaseManager, controller: CustomDialogController) {
    this.manager = manager;
    this.controller = controller;
  }

  /**
   * 设置应用静默状态
   * @param uid 应用uid
   * @Param bundleName 应用包名
   * @param enabled 是否置顶
   */
  public async setSilence(ntf: NotificationBase, enabled: boolean): Promise<boolean> {
    if (!this.manager) {
      log.showError(TAG, 'SilenceVm is not init');
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.SET_SILENT_NOTIFICATION_FAIL);
      return false;
    }
    this.silentAppLabel = ntf.appLabel;
    const isSuccess: boolean = await this.manager.setSilentState(ntf.creatorUid, ntf.creatorBundleName, enabled);
    NotificationSysEventReporter.notificationSilence({
      CREATOR_BUNDLE_NAME: ntf.creatorBundleName,
      IS_SILENCE_STATE_ON: enabled ? 1 : 0,
      TIME_STAMP: `${DropdownVm.instance.lastDropdownTime}`
    });
    ClickNotificationMaintenance.reportClick(isSuccess ? ClickNotificationErrorCode.SET_SILENT_NOTIFICATION_SUCC :
    ClickNotificationErrorCode.SET_SILENT_NOTIFICATION_FAIL);
    return isSuccess;
  }

  public openSilenceDialog() {
    this.dialogTitle = this.getDialogTitle();
    this.isSilenceDialogShow = true;
    this.isShowFlag = true;
    this.controller?.open();
    log.showInfo(TAG, 'openSilenceDialog');
  }

  public closeSilenceDialog() {
    this.isSilenceDialogShow = false;
    this.isShowFlag = false;
    this.controller?.close();
    log.showInfo(TAG, 'closeSilenceDialog');
  }

  public checkSilenceDialog(): string {
    try {
      let data = systemParameterEnhance.getSync('persist.systemui.silence', 'false');
      log.showDebug(TAG, `Get volume popup statue ${data}`);
      return data;
    } catch (error) {
      log.showInfo(TAG, 'Get volume popup statue failed:', error);
      return 'false';
    }
  }

  public setSilenceDialog(): void {
    try {
      systemParameterEnhance.setSync('persist.systemui.silence', 'true');
      log.showInfo(TAG, `Set silence dialog true`);
    } catch (error) {
      log.showInfo(TAG, 'Set silence dialog failed:', error?.message);
    }
  }

  public async onConfirm(): Promise<void> {
    const diagvm = this.vmInjector.getSettingDiagVm();
    if (diagvm) {
      await diagvm.silentNtf();
    }
    this.hide()
  }

  public onCancel(): void {
    this.hide();
  }

  /**
   * 弹框标题
   * @returns
   */
  public getDialogTitle(): string {
    return ResUtils.getInnerStringNumS($r('app.string.silence_dialog_title'), this.ntf?.appLabel);
  }

  /**
   * 隐藏显示通知设置弹窗
   */
  public hide(): void {
    const diagvm = this.vmInjector.getSettingDiagVm();
    if (diagvm) {
      log.showInfo(TAG, `statusbar reset`);
      diagvm.getStatusBarReset();
    }
    this.isSilenceDialogShow = false;
    this.isShowFlag = false;
    this.controller?.close();
    log.showInfo(TAG, `isSilenceDialogShow ${this.isSilenceDialogShow} isShowFlag ${this.isShowFlag}`);
    this.anim.executeAnimation([{
      duration: 100,
      curve: AIMATION_CURVE,
      event: () => this.vmInjector.getPanelVm()!.scale = 1,
    }]);
  }
}