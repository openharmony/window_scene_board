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

import { NotificationConfigBaseManager } from '../manager/NotificationConfigBaseManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationConfigEntity } from '../model/NotificationConfigEntity';
import { NotificationBaseVm } from '../notification/vm/NotificationBaseVm';
import { INotificationPinTopLimitDialogVm } from '../notification/interface/INotificationPinTopLimitDialogVm';
import { ArkUIAdapter, ViewName } from '../utils/ArkUIAdapter';
import { display, ComponentUtils } from '@kit.ArkUI';
import { ResourceVm } from './ResourceVm';
import { ClickNotificationErrorCode, ClickNotificationMaintenance } from '../maintenance/ClickNotificationMaintenance';
import { CustomPromise, DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { pinTopDialogConfigManager } from '../notification/vm/PinTopDialogConfigManager';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'PinTopVm');
/**
 * Grid子项的数据模型
 */
export class PinTopAppItem {
  public appBundle: string = '';
  public uid: number = 0;
  public appIcon: string | null = null;
  public appName: string = '';
  public isSelected: boolean = false;
  public appIndex: number = 0;
}

/**
 * 通知置顶ViewModel
 */
@ObservedV2
export class NotificationPinTopLimitDialogVm extends NotificationBaseVm implements INotificationPinTopLimitDialogVm {
  public isShow: boolean = false;
  /**
   * 每行最大图标数
   */
  public readonly colCount: number = 3;
  /**
   * 当前置顶的应用列表
   */
  public pinTopConfigList: Array<PinTopAppItem> = [];
  /**
   * 弹框副标题文本
   */
  public dialogContentText: string = ''
  /**
   * 所有组件加入滑动区
   */
  @Trace public isAllScroll:boolean = false;
  /**
   * 是否横屏布局
   */
  public isLandLayout: boolean = false;
  /**
   * 横屏时适老化布局
   */
  @Trace public isLandSuitableForOld: boolean = false;
  /**
   * 滚动区域的高度
   */
  @Trace public scrollerHeight: number = 0;
  /**
   * 滑动区最小高度，低于最小高度，整个页面可滑动
   */
  private readonly SCROLLER_MIN_HEIGHT = 100;
  /**
   * 字体放大倍数界限，超过之后启用适老化布局
   */
  private readonly FONT_SIZE_LIMIT_SCALE_FOR_OLD = 1.75;
  /**
   * 最大置顶应用数量
   */
  private readonly PIN_TOP_COUNT = 5;
  private manager?: NotificationConfigBaseManager;
  private controller?: CustomDialogController;
  private showDialogPromise?: CustomPromise<number[]>;
  /**
   * 状态栏高度
   */
  private statusBarHeight: number = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
  /**
   * 横屏的最大高度
   */
  private landHeight: number = 0;
  /**
   * 横屏时Grid的高度
   */
  private itemHeight: number = 0;
  /**
   * 副标题实际高度
   */
  private contentTextHeight: number = 0;
  /**
   * 置顶上限弹框高度
   */
  private dialogHeight: number = 0;
  /**
   * ComponentUtils对象
   */
  private componentUtils: ComponentUtils | undefined =
    ArkUIAdapter.getUiContextByViewName(ViewName.DROPDOWN_VIEW)?.getComponentUtils();
  /**
   * 返回、ESC键和点击遮障层弹窗退出时的回调。
   */
  public cancel = () => {
    log.showInfo('Click the callback in the blank area');
    this.showDialogPromise?.resolve([]);
    this.isShow = false;
  }

  public init(manager: NotificationConfigBaseManager, controller: CustomDialogController): void {
    this.manager = manager;
    this.controller = controller;
  }

  public destroy(): void {
    this.manager = undefined;
    this.controller = undefined;
  }

  /**
   * 取消按钮回调。
   */
  public onCancel() {
    log.showInfo('Cancel for select canceled pin top appList');
    this.controller?.close();
    this.showDialogPromise?.resolve([]);
    this.isShow = false;
  }
  /**
   * 确认按钮回调
   * @param selected 选中需要取消置顶的应用集合
   */
  public onSubmit(selected: Set<PinTopAppItem>) {
    log.showInfo('Submit for select canceled pin top appList');
    this.controller?.close();
    let uidList: number[] = [];
    selected.forEach(item => {
      uidList.push(item.uid);
    })
    this.showDialogPromise?.resolve(uidList);
    this.isShow = false;
  }
  /**
   * 设置应用置顶状态
   * @param uid 应用uid
   * @param enabled 是否置顶
   */
  public async setPinTop(uid: number, enabled: boolean): Promise<boolean> {
    if (!this.manager) {
      log.showError('PinTopVm is not init');
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.SET_PIN_TOP_FAIL);
      return false;
    }
    if (!enabled) {
      const isSuccess: boolean = await this.manager.setPinTopState(uid, enabled);
      ClickNotificationMaintenance.reportClick(isSuccess ? ClickNotificationErrorCode.SET_PIN_TOP_SUCC :
        ClickNotificationErrorCode.SET_PIN_TOP_FAIL);
      return isSuccess;
    }
    // 打开置顶时需要检测当前置顶数量是否超限
    const currentPinTopList = await this.manager.getPinTopList();
    await this.refreshPinTopDialogData(currentPinTopList);

    if (currentPinTopList.length >= this.PIN_TOP_COUNT) {
      const cancelPinTopList = await this.showPinTopDialog();
      if (!cancelPinTopList.length || !await this.manager.batchCancelPinTopState(cancelPinTopList)) {
        return false;
      }
    }
    const isSuccess: boolean = await this.manager.setPinTopState(uid, enabled);
    ClickNotificationMaintenance.reportClick(isSuccess ? ClickNotificationErrorCode.SET_PIN_TOP_SUCC :
      ClickNotificationErrorCode.SET_PIN_TOP_FAIL);
    return isSuccess;
  }

  /**
   * 设置对话框是否显示
   */
  public isDialogOpen(): boolean {
    return Boolean(this.showDialogPromise);
  }

  /**
   * 设置弹窗当前高度
   */
  public setDialogHeight = (dialogHeight:  Length | undefined): void => {
    if (dialogHeight) {
      this.dialogHeight = Number(dialogHeight);
    }
  }

  /**
   * 设置当前副标题高度
   */
  public setContentTextHeight = (contentTextID: string): void => {
    const contentTextHeight = this.componentUtils?.getRectangleById(contentTextID)?.size.height;
    if (contentTextHeight) {
      this.contentTextHeight = ArkUIAdapter.px2vp(contentTextHeight);
    }
  }

  /**
   * 获取弹窗内所有子组件高度和
   * @returns
   */
  public getAllSubcomponentHeight(): number {
    const allSubcomponentHeight: number =
      this.getTitleHeight() + this.contentTextHeight + this.gridLayoutHeight() + this.getButtonHeight() +
        pinTopDialogConfigManager.getConfig().buttonOutTopMargin * 2;
    log.showInfo('allSubcomponentHeight: ' + allSubcomponentHeight);
    return allSubcomponentHeight;
  }

  /**
   * 刷新是否所有子组件都添加进滚动条的状态
   */
  public refreshIsAllScroll = (dialogHeight:  Length | undefined, contentTextID: string): void => {
    if (this.isLandLayout || ResourceVm.instance.fontScale < this.FONT_SIZE_LIMIT_SCALE_FOR_OLD) {
      return;
    }
    this.setDialogHeight(dialogHeight);
    this.setContentTextHeight(contentTextID);
    this.isAllScroll = this.getIsAllScroll();
    this.computeScrollerHeight();
    log.showInfo('refreshIsAllScroll end, dialogHeight: ' + this.dialogHeight + ', contentTextHeight: ' +
    this.contentTextHeight + ', isAllScroll: ' + this.isAllScroll);
  }

  private async refreshPinTopDialogData(currentPinTopList: NotificationConfigEntity[]) {
    this.dialogContentText = await ResUtils.getInnerPlural($r('app.plural.ntf_pin_top_dialog_reach_limit_content'),
      this.PIN_TOP_COUNT)

    this.pinTopConfigList = [];
    for (const item of currentPinTopList) {
      this.pinTopConfigList.push({
        appBundle: item.bundle,
        uid: item.uid,
        appName: item.label,
        appIcon: item.icon,
        isSelected: true,
        appIndex: item.appIndex
      });
    }

    if (DeviceHelper.isLandscape()) {
      try {
        const defaultDisplay: display.Display = display.getDefaultDisplaySync();
        const disHeight = px2vp(defaultDisplay.height);
        this.landHeight = (disHeight - this.statusBarHeight) * 0.9;
        this.isLandLayout = this.getIsLandLayout();
        this.isLandSuitableForOld = this.getIsLandSuitableForOld();
        this.isAllScroll = this.getIsAllScroll();
      } catch (error) {
        log.showError(`getFoldStatus failed, err:${error}`);
      }
    } else {
      this.isLandLayout = false;
      this.isLandSuitableForOld = false;
      this.isAllScroll = false;
    }
    this.computeScrollerHeight();
  }
  /**
   * 是否采用横屏布局
   */
  private getIsLandLayout(): boolean {
    try {
      let foldStatus = display.getFoldStatus();
      // 小折叠按直板机处理
      if (DeviceHelper.isSmallFoldProduct()) {
        return true;
      }
      // 大大屏幕机，折叠态按直板机处理
      if (DeviceHelper.isFold()) {
        return foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED;
      }
      // PAD无横屏展示，直板机或平板跟随屏方向：横屏显示
      return !DeviceHelper.isPad();
    } catch (error) {
      log.showError(`getFoldStatus failed, err:${error}`);
      return false;
    }
  }

  /**
   * 横屏布局时，是否采用适老化布局
   */
  private getIsLandSuitableForOld(): boolean {
    if (!this.isLandLayout) {
      return false;
    }
    // 大于等于界限，启用适老化布局
    return ResourceVm.instance.fontScale >= this.FONT_SIZE_LIMIT_SCALE_FOR_OLD;
  }

  private getIsAllScroll(): boolean {
    if (!this.isLandSuitableForOld) {
      if (!DeviceHelper.isLandscape() && this.getAllSubcomponentHeight() > Math.ceil(this.dialogHeight)) {
        return true;
      }
      return false;
    }
    let gridHeight = this.landHeight - this.getTitleHeight() - this.getButtonHeight();
    return gridHeight < this.SCROLLER_MIN_HEIGHT;
  }

  private getButtonHeight(): number {
    return ResUtils.getNumberFromLength($r('app.float.ntf_setting_dialog_item_height')) *
    ResourceVm.instance.limitFontScale +
    ResUtils.getNumberFromLength($r('app.float.ntf_settings_dialog_bottom_button_margin_top')) +
    ResUtils.getNumberFromLength($r('app.float.ntf_pin_top_bottom_button_margin_bottom'))
  }

  private getTitleHeight(): number {
    return ResUtils.getNumberFromLength($r('app.float.ntf_settings_dialog_title_height')) *
    ResourceVm.instance.limitFontScale;
  }

  private gridLandHeight(): number {
    // 按钮高度
    let buttonHeight = this.getButtonHeight();
    this.itemHeight = this.landHeight - this.getTitleHeight() - buttonHeight;
    // 适老化布局时，宽度小于100vp，全部区域可滑动
    if (this.isLandSuitableForOld && this.itemHeight < this.SCROLLER_MIN_HEIGHT) {
      this.itemHeight = this.landHeight;
      log.showInfo(`gridLandHeight, itemHeight:${this.itemHeight}, landHeight:${this.landHeight}`);
      return this.itemHeight;
    }
    if (!this.isLandSuitableForOld) {
      // 副标题高度
      let contentHeight = ResUtils.getNumberFromLength($r('app.float.ntf_settings_dialog_content_line_height')) *
      ResourceVm.instance.limitFontScale * 2;
      // 非适老化布局，副标题放在滑动区外面
      this.itemHeight = this.itemHeight - contentHeight;
    }
    log.showInfo(`gridLandHeight, itemHeight:${this.itemHeight}, landHeight:${this.landHeight}`);
    return this.itemHeight;
  }

  private gridLayoutHeight(): number {
    let rowCount = Math.ceil(this.pinTopConfigList.length / this.colCount);
    let itemHeight =
      ResUtils.getNumberFromLength($r('app.float.ntf_pin_top_app_icon_size')) +
        ResUtils.getNumberFromLength($r('app.float.ntf_pin_top_app_icon_margin')) * 2 +
      ResUtils.getNumberFromLength($r('app.float.ntf_pin_top_app_name_line_height'));
    let totalRowsHeight = itemHeight * rowCount;
    let totalGapHeight = ResUtils.getNumberFromLength($r('app.float.ntf_pin_top_app_row_margin_gap')) * (rowCount - 1)
    let verticalTotalPadding = ResUtils.getNumberFromLength($r('app.float.ntf_pin_top_app_layout_margin')) * 2;
    return totalRowsHeight + totalGapHeight + verticalTotalPadding;
  }

  private computeScrollerHeight(): void {
    if (this.isLandLayout) {
      this.scrollerHeight = this.gridLandHeight();
      return;
    }
    this.scrollerHeight = this.isAllScroll ? this.dialogHeight : this.gridLayoutHeight();
  }

  private async showPinTopDialog(): Promise<number[]> {
    this.showDialogPromise = new CustomPromise<number[]>();
    this.showDialogPromise.then(() => {
      this.showDialogPromise = undefined;
    })
    this.controller?.open();
    this.isShow = true;
    return this.showDialogPromise;
  }
}