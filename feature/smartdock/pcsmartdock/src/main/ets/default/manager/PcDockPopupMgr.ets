/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { DockItemInfo, EventConstants, ReceiveEventInfo, SnapshotInfo } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DockInfo, IconResourceManager, localEventManager } from '@ohos/frameworkwrapper';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { BaseViewController } from '@ohos/frameworkcommon/src/main/ets/TsIndex';
import { FixedDockResource } from '../common/constants/FixedDockConstants';
import PcSmartDockViewModel from '../viewmodel/SmartDockViewModel';

const TAG = 'PcDockPopupMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

const INVALID_TIMER: number = -1;

enum PopupStatus {
  SHOWING,
  SHOWED,
  HIDING,
  HIDED,
};

interface ViewCallback {
  onShow: Function;
  onHide: Function;
}

class Timer {
  private timerId: number = INVALID_TIMER;
  private isPreview: boolean = false;
  private delayTime: number = 0; // 任务等待执行时间
  private action: ViewCallback | undefined;
  private id: string = '';

  public initTimer(action: ViewCallback, id: string, isPreview: boolean) {
    this.action = action;
    this.id = id;
    this.isPreview = isPreview;
  }

  public setDelay(delay: number): void {
    log.showInfo(`timer:${this.id} setDelay: delay:${delay}`);
    this.delayTime = delay;
  }

  // 有些定时器需要刷新，刷新定时器
  public start(screenId: number, isShow: boolean, item?: DockItemInfo, itemId?: string, isAnim?: boolean): void {
    if (this.action === undefined) {
      return;
    }
    this.stop();
    if (this.delayTime === 0) {
      this.doAction(screenId, isShow, item, itemId, isAnim);
    } else {
      this.timerId = setTimeout(() => {
        this.doAction(screenId, isShow, item, itemId, isAnim);
        this.timerId = INVALID_TIMER;
      }, this.delayTime);
    }
    log.showInfo(`timer:${this.id} start id: ${this.timerId} ${isShow} delay:${this.delayTime}`);
  }

  private doAction(screenId: number, isShow: boolean, item?: DockItemInfo, id?: string, isAnim?: boolean): void {
    log.showInfo(`doAction timer:${this.id} start id: ${this.timerId} ${isShow} delay:${this.delayTime}`);
    if (isShow) {
      this.action?.onShow(this, screenId, item, id);
    } else {
      this.action?.onHide(this, screenId, isAnim);
    }
  }

  // 取消任务
  public stop(): void {
    if (this.timerId != INVALID_TIMER) {
      log.showWarn(`stop : clearTimeout: ${this.timerId}`);
      clearTimeout(this.timerId);
      this.timerId = INVALID_TIMER;
    }
  }
}

class PopupInfo {
  public isHoverSnapshot: boolean = false;
  public isDockMenuShow: boolean = false;
  public isDockPopupShow: boolean = false;
}

export class PcDockPopupMgr {
  private static instance: PcDockPopupMgr;
  private curShowingItem: DockItemInfo | null = null;
  private curShowingItemId: string = '';
  private popupStatus: PopupStatus = PopupStatus.HIDED;
  private currItem: DockItemInfo | null = null;
  private currItemIcon: PixelMap | null = null;
  private tipsTimer: Timer = new Timer();
  private previewTimers: Map<number, Timer> = new Map();
  private isCurItemNeedRefreshUI: Map<number, boolean> = new Map();
  private isShowCloseButton: boolean = false;
  private popupPanelCtrl: Map<number, BaseViewController> = new Map();
  private updateCallbackMap: Map<number, Function> = new Map();
  private popupInfo: Map<number, PopupInfo> = new Map();

  private constructor() {
    this.init();
    log.showInfo('PcDockPopupMgr constructor');
  }

  static getInstance(): PcDockPopupMgr {
    if (!PcDockPopupMgr.instance) {
      PcDockPopupMgr.instance = new PcDockPopupMgr();
    }
    return PcDockPopupMgr.instance;
  }

  private getPopupInfo(screenId: number) {
    let info: PopupInfo | undefined = this.popupInfo.get(screenId);
    if (!info) {
      info = new PopupInfo();
      this.popupInfo.set(screenId, info);
    }
    return info;
  }

  public registerViewController(controller: BaseViewController, screenId: number): void {
    this.popupPanelCtrl.set(screenId, controller);
  }

  public unregisterViewController(screenId: number): void {
    this.popupPanelCtrl.delete(screenId);
  }

  public registerUpdateCallback(screenId: number, callback: Function): void {
    this.updateCallbackMap.set(screenId, callback);
  }

  public unRegisterUpdateCallback(screenId: number): void {
    this.updateCallbackMap.delete(screenId);
  }

  private registerPcDockListener(): void {
    localEventManager.registerEventListener(this.pcDockListener,
      [EventConstants.EVENT_PC_DOCK_CLOSE_POPUP,
        EventConstants.EVENT_DOCK_POPUP_VISIBLE_CHANGE,
        EventConstants.EVENT_DOCK_MENU_VISIBLE_CHANGE]);
    log.showInfo('Launcher PcDockAnimationMgr local listener on create');
  }

  public unRegisterPcDockListener(): void {
    localEventManager.unregisterEventListener(this.pcDockListener);
  }

  private readonly pcDockListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: object): void => {
      log.showInfo(`pcDockListener, receive event : ${event}`);
      if (event === EventConstants.EVENT_PC_DOCK_CLOSE_POPUP) {
        this.closePopup();
        this.popupInfo.forEach((value: PopupInfo)=>{
          value.isHoverSnapshot = false;
        })
      } else if (event === EventConstants.EVENT_DOCK_POPUP_VISIBLE_CHANGE) {
        const info = (params as DockInfo);
        this.setIsDockPopupShow(info.screenId, info.isVisible);
      } else if (event === EventConstants.EVENT_DOCK_MENU_VISIBLE_CHANGE) {
        const info = (params as DockInfo);
        this.setIsDockMenuShow(info.screenId, info.isVisible);
      }
    }
  };

  private closePopup() {
    this.popupPanelCtrl.forEach((controller: BaseViewController, screenId: number)=>{
      this.hide(screenId);
    })
  }

  private callback: ViewCallback = {
    onShow: (timer: Timer, screenId: number, item: DockItemInfo, itemId: string) => {
      log.showInfo(`showPopup. curShowingItem: ${this.curShowingItem?.bundleName} ${itemId}`);
      if (this.checkIsRunning(item)) {
        PcSmartDockViewModel.getInstance().onHoverEvent?.(item, true);
      }
      if (item === undefined || itemId === undefined) {
        log.showInfo(`showPopup. undefined`);
        return;
      }
      if (!this.isSameDockItem(this.currItem, item) && this.checkIsRunning(item)) {
        log.showWarn(`showPopup ${item.bundleName} onFinish return. currItem ${this.currItem?.bundleName} not correct`);
        return;
      }
      this.curShowingItem = item;
      this.curShowingItemId = itemId;
      if (!this.checkCurItem(item)) {
        this.isCurItemNeedRefreshUI.set(screenId, true);
        log.showWarn(`showPopup ${item.bundleName} return with snapshot not ready delay`);
        this.popupStatus = PopupStatus.SHOWING;
        return;
      }
      if (this.popupPanelCtrl.get(screenId)?.isShowing()) {
        animateTo({
          duration: FixedDockResource.HOVER_ENTER_ANIM_DURATION,
          curve: Curve.Sharp
        }, () => {
          this.popupStatus = PopupStatus.SHOWED;
          this.updateCallbackMap.get(screenId)?.();
        });
      } else {
        this.popupPanelCtrl.get(screenId)?.show();
        animateTo({
          duration: FixedDockResource.HOVER_ENTER_ANIM_DURATION,
          curve: Curve.Sharp
        }, () => {
          this.popupStatus = PopupStatus.SHOWING;
          this.popupPanelCtrl.get(screenId)?.setOpacity(1);
        });
      }
    },
    onHide: (timer: Timer, screenId: number, isAnim: boolean = true) => {
      log.showInfo(`hidePopup. curShowingItem: ${this.curShowingItem?.bundleName}`);
      const isHoverSnapshot = this.isHoverSnapshot(screenId) as boolean;
      if (isHoverSnapshot) {
        this.popupStatus = PopupStatus.SHOWED;
        this.popupPanelCtrl.get(screenId)?.setOpacity(1);
        return;
      }
      this.isCurItemNeedRefreshUI.set(screenId, false);
      if (!isAnim) {
        this.popupPanelCtrl.get(screenId)?.setOpacity(0);
        this.curShowingItem = null;
        this.curShowingItemId = '';
        this.popupPanelCtrl.get(screenId)?.hide();
        this.popupStatus = PopupStatus.HIDED;
        return;
      }
      if (!this.popupPanelCtrl.get(screenId)?.isShowing()) {
        this.popupStatus = PopupStatus.HIDED;
        return;
      }
      animateTo({
        duration: FixedDockResource.HOVER_EXIT_ANIM_DURATION,
        curve: Curve.Sharp,
        onFinish: () => {
          if (this.popupStatus !== PopupStatus.HIDING) {
            log.showInfo('hidePopup is interrupted');
            return;
          }
          const isHoverSnapshot = this.isHoverSnapshot(screenId) as boolean;
          if (isHoverSnapshot) {
            this.popupStatus = PopupStatus.SHOWED;
            this.popupPanelCtrl.get(screenId)?.setOpacity(1);
            log.showWarn(`hidePopup onFinish return. isHoverSnapshot is true`);
            return;
          }
          log.showInfo('hidePopup finish!!');
          this.curShowingItem = null;
          this.curShowingItemId = '';
          this.popupPanelCtrl.get(screenId)?.hide();
          this.popupStatus = PopupStatus.HIDED;
        }
      }, () => {
        this.popupStatus = PopupStatus.HIDING;
        this.popupPanelCtrl.get(screenId)?.setOpacity(0);
      });
    }
  }

  private getPreviewTimer(screenId: number): Timer {
    let timer = this.previewTimers.get(screenId);
    if (timer === undefined) {
      timer = new Timer();
      timer.initTimer(this.callback, 'preview', true);
      this.previewTimers.set(screenId, timer);
    }
    return timer;
  }

  public show(screenId: number, item: DockItemInfo, itemId: string, delay: number = 0): void {
    if (CheckEmptyUtils.isEmpty(item?.bundleName)) {
      log.showInfo('show error. item.bundleName is null');
      return;
    }
    log.showInfo(`show ${item.bundleName}, delay: ${delay}, screenId: ${screenId}` +
      ` curShowingItem: ${this.curShowingItem?.bundleName}`);
    const isPreview: boolean = this.checkIsRunning(item);
    if (isPreview) {
      this.isCurItemNeedRefreshUI.set(screenId, true);
      this.tipsTimer.stop();
      this.getPreviewTimer(screenId).setDelay(delay);
      this.getPreviewTimer(screenId).start(screenId, true, item, itemId);
    } else {
      this.tipsTimer.setDelay(delay);
      this.tipsTimer.start(screenId, true, item, itemId);
    }
  }

  private showInner(screenId: number, item: DockItemInfo, itemId: string, delay: number, isPreview: boolean): void {
    if (item.bundleName === '') {
      log.showInfo('show error. item.bundleName is null');
      return;
    }
    log.showInfo(`showInner ${item.bundleName}, delay: ${delay}, screenId: ${screenId}` +
      ` curShowingItem: ${this.curShowingItem?.bundleName}`);
    if (isPreview) {
      this.tipsTimer.stop();
      this.getPreviewTimer(screenId).setDelay(delay);
      this.getPreviewTimer(screenId).start(screenId, true, item, itemId);
    } else {
      this.tipsTimer.setDelay(delay);
      this.tipsTimer.start(screenId, true, item, itemId);
    }
  }

  /**
   * 隐藏 popup
   * @param delay 隐藏延迟时间
   * @param withAnim 是否使用隐藏动画, (非 hover false 场景下建议不要动画，因为可能会影响其他动画效果)
   */
  public hide(screenId: number, delay: number = 0, withAnim: boolean = false): void {
    log.showInfo(`hide, delay: ${delay}.`);
    if (this.currItem === undefined || this.curShowingItem === undefined) {
      return;
    }
    const isPreview: boolean = this.checkIsRunning(this.currItem!);
    this.tipsTimer.stop();
    this.getPreviewTimer(screenId).stop();
    if (isPreview) {
      this.getPreviewTimer(screenId).setDelay(delay);
      this.getPreviewTimer(screenId).start(screenId, false, undefined, undefined, withAnim);
    } else if (this.curShowingItem === undefined || !this.checkIsRunning(this.curShowingItem!)) {
      this.tipsTimer.setDelay(FixedDockResource.HOVER_EXIT_DELAY_TIME_TIPS);
      this.tipsTimer.start(screenId, false, undefined, undefined, withAnim);
    }
  }

  private hideInner(screenId: number, delay: number, isPreview: boolean): void {
    log.showInfo(`hideInner, delay: ${delay} isPreview:${isPreview}.`);
    if (this.currItem === undefined || this.curShowingItem === undefined) {
      return;
    }
    if (isPreview) {
      this.getPreviewTimer(screenId).setDelay(delay);
      this.getPreviewTimer(screenId).start(screenId, false);
    } else {
      this.tipsTimer.stop();
    }
    if (this.curShowingItem === undefined || !this.checkIsRunning(this.curShowingItem!)) {
      this.tipsTimer.setDelay(delay);
      this.tipsTimer.start(screenId, false);
    }
  }

  public updateHoverState(screenId: number, item: DockItemInfo, itemId: string,
    isDockInDragging: boolean, isHover: boolean): void {
    log.showInfo(`updateHoverStart hover:${isHover} status:${this.popupStatus}`);
    const isPreview: boolean = this.checkIsRunning(item);
    if (isHover && !isDockInDragging) {
      if (isPreview) {
        this.currItem = item;
      }
      let delayTime: number = FixedDockResource.HOVER_ENTER_DELAY_TIME_TIPS;
      if (isPreview) {
        delayTime = this.popupStatus === PopupStatus.HIDED ? FixedDockResource.HOVER_ENTER_DOCK_DELAY_TIME_PREVIEW :
          FixedDockResource.HOVER_ENTER_DELAY_TIME_PREVIEW;
      }
      this.showInner(screenId, item, itemId, delayTime, isPreview);
    } else if (!isHover) {
      const delayTime: number = (!isPreview || isDockInDragging) ?
      FixedDockResource.HOVER_EXIT_DELAY_TIME_TIPS : FixedDockResource.HOVER_EXIT_DELAY_TIME_PREVIEW;
      this.hideInner(screenId, delayTime, isPreview);
    }
  }

  public getCurShowingItem(): DockItemInfo | null {
    return this.curShowingItem;
  }

  public getCurShowingItemId(): string {
    return this.curShowingItemId;
  }

  public getIsShowCloseButton(): boolean {
    return this.isShowCloseButton;
  }

  public setIsShowCloseButton(value: boolean): void {
    this.isShowCloseButton = value;
  }

  public isItemPopupShowing(info: DockItemInfo): boolean {
    if (!this.curShowingItem) {
      return false;
    }
    return (info?.shortcutId ?? '') === (this.curShowingItem?.shortcutId ?? '') &&
      (info?.bundleName ?? '') === (this.curShowingItem?.bundleName ?? '') &&
      (info?.appIndex ?? '') === (this.curShowingItem?.appIndex ?? '') &&
      (info?.abilityName ?? '') === (this.curShowingItem?.abilityName ?? '') &&
      (info?.persistentId ?? '') === (this.curShowingItem?.persistentId ?? '');
  }

  public async updateCurItemIcon(item: DockItemInfo): Promise<void> {
    log.showInfo(`updateCurItemIcon ${item.bundleName}`);
    try {
      const iconImage = await IconResourceManager.getInstance().getCombIcon(item.bundleName,
        item.moduleName, item.abilityName);
      if (!iconImage || CheckEmptyUtils.isEmpty(iconImage)) {
        log.error(`updateCurItemIcon ${item.bundleName} error, iconImage is null`);
        return;
      }
      this.currItemIcon = iconImage;
      log.showInfo('updateCurItemIcon success');
    } catch (error) {
      log.error(`updateCurItemIcon ${item.bundleName} error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  public getCurItemIcon(): PixelMap | null {
    return this.currItemIcon;
  }

  public getCurItemNeedRefreshUI(screenId: number): boolean {
    return this.isCurItemNeedRefreshUI.get(screenId) ?? false;
  }

  public setCurItemNeedRefreshUI(screenId: number, value: boolean): void {
    this.isCurItemNeedRefreshUI.set(screenId, value);
  }

  private checkCurItem(item: DockItemInfo): boolean {
    const curItemBundleName = this.currItem?.bundleName ?? '';
    const snapshotList: SnapshotInfo[] = AppStorage.get<SnapshotInfo[]>('snapshotList') as SnapshotInfo[];
    const snapshotListBundleName = snapshotList.length > 0 ? snapshotList[0].bundleName : '';
    if (this.checkIsRunning(item) && curItemBundleName !== '' && curItemBundleName !== snapshotListBundleName) {
      log.showWarn(`checkCurItem ${item.bundleName} return false`);
      return false;
    }
    return true;
  }

  private isSameDockItem(info1: DockItemInfo | null, info2: DockItemInfo | null): boolean {
    if (!info1 || !info2) {
      return false;
    }
    return info1.shortcutId === info2.shortcutId &&
      info1.bundleName === info2.bundleName &&
      info1.appIndex === info2.appIndex &&
      info1.abilityName === info2.abilityName &&
      info1.persistentId === info2.persistentId;
  }

  private checkIsRunning(item: DockItemInfo): boolean {
    return SmartDockModel.getInstance().checkAppIsRunning(item);
  }

  private init(): void {
    this.curShowingItem = null;
    this.curShowingItemId = '';
    this.currItem = null;
    this.tipsTimer.initTimer(this.callback, 'tips', false);
    this.registerPcDockListener();
  }

  public setCurrItem(item: DockItemInfo | null): void {
    this.currItem = item;
  }

  public getCurrItem(): DockItemInfo | null {
    return this.currItem;
  }

  public hideOnClickItem(screenId: number, item: DockItemInfo): void {
    if (this.isPopupShowing(screenId, item)) {
      log.showInfo('current item popup is showing, no need hide');
      return;
    }
    this.hide(screenId);
  }

  public isPopupShowing(screenId: number, item: DockItemInfo): boolean {
    return this.checkIsRunning(item) && this.isSameDockItem(item, this.curShowingItem) &&
      (this.popupPanelCtrl.get(screenId)?.isShowing() ?? false);
  }

  public setIsHoverSnapshot(screenId: number, isHoverSnapshot: boolean): void {
    this.getPopupInfo(screenId).isHoverSnapshot = isHoverSnapshot;
  }

  public isHoverSnapshot(screenId: number): boolean {
    return this.getPopupInfo(screenId).isHoverSnapshot;
  }

  public setIsDockMenuShow(screenId: number, isDockMenuShow: boolean): void {
    this.getPopupInfo(screenId).isDockMenuShow = isDockMenuShow;
  }

  public closeMenu(): void {
    this.popupInfo.forEach((item) => {
      item.isDockMenuShow = false;
    })
  }

  public isDockMenuShow(screenId: number): boolean {
    return this.getPopupInfo(screenId).isDockMenuShow;
  }

  public setIsDockPopupShow(screenId: number, isDockPopupShow: boolean): void {
    this.getPopupInfo(screenId).isDockPopupShow = isDockPopupShow;
  }

  public isDockPopupShow(screenId: number): boolean {
    return this.getPopupInfo(screenId).isDockPopupShow;
  }
}