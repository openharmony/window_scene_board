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

import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { GlobalContext, HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper';
import { windowManager} from '@ohos/componentdrag';
import {
  AppGridStyleConfig, CalculateAppCenterRst, ReceiveEventInfo, StyleConstants
} from '@ohos/launchercommon';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LayoutViewModel } from '@ohos/launchercommon';
import { AppItemInfo } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { AppCenterItem } from './AppCenterItem';
import FeatureConstants from '../common/constants/FeatureConstants';
import AppGridLayoutCacheManager from '../common/cache/AppGridLayoutCacheManager';
import AppGridLayoutUtil from '../common/util/AppGridLayoutUtil';
import { FoldedDeviceAcViewModel, FoldStatusChangeEvent, SCBFoldedState } from '../folded/FoldedDeviceAcViewModel';
import { AppCenterViewModel } from '../common/viewmodel/AppCenterViewModel';
import { SCBPropertyChangeReason,
  SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { AppCenterDragMgr } from '../controller/AppCenterDragMgr';
import { RTLUtil } from '@ohos/componenthelper';
import { curves } from '@kit.ArkUI';
import { AC_DRAG_SQUEEZE_DURATION } from '../constants/LayoutConstants';


const TAG = 'AppCenterAppGrid';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_ICON_RADIUS = 20;
const FOLD_TO_UNFOLDED_DURATION = 400;

/**
 * 应用中心网格布局
 */
@Component
export struct AppCenterAppGrid {
  @Prop screenProp: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  private traceId: string = TAG;
  private mLayoutVM?: LayoutViewModel;
  private getIndexInSwiper: Function = (): number => 0;
  appGridStyleConfig: AppGridStyleConfig = AppGridStyleConfig.getInstance();
  onItemClick?: Function;
  buildMenu?: Function;
  buildNotInstalledAppMenu?: Function;
  dragStart?: Function;
  dragEnd?: Function;
  @State
  appGridList: AppItemInfo[] = [];
  @StorageLink('updateAppGridPageData') @Watch('updateAppGridList')
  updatePageData: boolean = true;
  @State gridOptions: GridLayoutOptions | undefined =
    AppGridLayoutUtil.getGridLayoutOptions(this.appGridList, this.screenProp.screenId);
  private updateCurrentPageCallBack: Function = (): void => this.updateCurrentPageEvent();
  private updateGridOptionCallBack: Function = (): void => this.updateGridOptionEvent();
  pageIndex: number = 0;
  @State
  isScroll: boolean = false;
  isDragFlag: boolean = false;
  @State inSearch: boolean = false;
  @State iconRadius: number = DEFAULT_ICON_RADIUS;
  @State nameSize: number = 0;
  @State appCenterBubbleMarginTop: number = 0;
  @State appCenterBubbleMarginBottom: number = 0;
  @Prop isGainFocus: boolean = false;
  private dragAllowed: boolean = true;

  /**
   * 三指跟手动效相关参数
   */
  private appItemPosX: number[] = [];
  private rtlAppItemPosX: number[] = [];
  private appItemPosY: number[] = [];
  private appItemOpacity: number[] = [];
  private bkOpacity: number = 0;
  @State idpAppItemPosX: number[] = [];
  @State idpRtlAppItemPosX: number[] = [];
  @State idpAppItemPosY: number[] = [];
  @State idpAppItemOpacity: number[] = [];
  private appCenterRst?: CalculateAppCenterRst;
  private mIconNameMargin?: number = StyleConstants.DEFAULT_6;
  private enableBadge: boolean = true;
  /**
   * 应用图标相关参数
   */
  @Provide
  pageDesktopDragItemInfo: AppItemInfo = new AppItemInfo();
  @Provide
  titleDisappearStatus: boolean = false;
  @State
  isDragStart: boolean = false;
  @Provide
  isFocused: boolean = false;

  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  @State acGridPaddingTop:number = 0;
  @State acGridPaddingBottom:number = 0;
  @State acGridPaddingLeft:number = 0;
  @State acColumns: number = AppCenterViewModel.getInstance().getAppGridStyleConfig(this.screenProp.screenId).mColumns;
  @State acRows: number = AppCenterViewModel.getInstance().getAppGridStyleConfig(this.screenProp.screenId).mRows;
  @State acFirstGridPaddingTop: number = 0;
  @State acFirstGridPaddingBottom: number = 0;
  @State acSecondGridPaddingTop: number = 0;
  @State acSecondGridPaddingBottom: number = 0;
  @State iconSize: number = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;
  @Link swiperPaddingBottom: number;
  private currentScreenHeight: number = this.screenProp.height;
  private currentScreenWidth: number = this.screenProp.width;

  private readonly foldStateChangeListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: FoldStatusChangeEvent): void => {
      log.showInfo(`hopper state change event-in grid received: ${event}, params: ${JSON.stringify(params)}`);
      let cs: number = params.curState;
      let ts: number = params.tarState;
      this.nameSize = AppCenterViewModel.getInstance().getAppGridStyleConfig(this.screenProp.screenId).mNameSize;
      this.resetGridPadding(cs, true, ts);
      if (cs === SCBFoldedState.HALF_FOLDED && ts === SCBFoldedState.UNFOLDED_VERTICAL) {
        log.showInfo(`hopper state change in grid - from half-folded to unfolded-vertical`);
        return;
      }
      if (cs === SCBFoldedState.UNFOLDED_VERTICAL && ts === SCBFoldedState.HALF_FOLDED) {
        log.showInfo(`hopper state change in grid - from unfolded-vertical to half-folded`);
        return;
      }
      if (cs === SCBFoldedState.UNFOLDED_VERTICAL && ts === SCBFoldedState.UNFOLDED_HORIZONTAL) {
        log.showInfo(`hopper state change in grid - from unfolded-vertical to unfolded-HORIZONTAL-${this.appGridStyleConfig.mAppCenterMarginLeft}`);
        this.acColumns = this.appGridStyleConfig.mColumns;
        this.acRows = this.appGridStyleConfig.mRows;
        this.acGridPaddingLeft = this.appGridStyleConfig.mAppCenterMarginLeft;
        this.updateCurrentPageEvent();
      }
      if (cs === SCBFoldedState.UNFOLDED_HORIZONTAL && ts === SCBFoldedState.UNFOLDED_VERTICAL) {
        log.showInfo(`hopper state change in grid - from unfolded-HORIZONTAL to unfolded-vertical-${this.appGridStyleConfig.mAppCenterMarginLeft}`);
        let oldColMax = this.acColumns;
        this.acColumns = this.appGridStyleConfig.mColumns;
        this.acRows = this.appGridStyleConfig.mRows;
        this.acGridPaddingLeft = this.appGridStyleConfig.mAppCenterMarginLeft;
        this.updateCurrentPageEvent();
      }
    }
  };

  private resetGridPadding(cs: SCBFoldedState, isNeedResetPaddingAnimation: boolean, ts?: SCBFoldedState): void {
    let gTop: number = AppCenterViewModel.getInstance().
    getAppGridStyleConfig(this.screenProp.screenId).mAppCenterMarginTop;
    let gBottom: number = AppCenterViewModel.getInstance().
    getAppGridStyleConfig(this.screenProp.screenId).mAppCenterMarginBottom;
    let gSpace: number = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getSwiperItemSpace();
    let singleGridSpace: number = (gTop + gBottom + gSpace) / 2;

    if (ts === SCBFoldedState.HALF_FOLDED_PHYSICAL_KEYBOARD && cs === SCBFoldedState.HALF_FOLDED) {
      this.acFirstGridPaddingBottom = this.acGridPaddingBottom;
      this.acSecondGridPaddingTop = gTop + this.acGridPaddingTop;
      this.acSecondGridPaddingBottom = this.acGridPaddingBottom;
      this.swiperPaddingBottom = gBottom;
      log.showInfo(`rgp1 firstPadding[top,bottom]=${this.acFirstGridPaddingTop},${this.acFirstGridPaddingBottom} ` +
        `- secondPadding[top,bottom]=${this.acSecondGridPaddingTop},${this.acSecondGridPaddingBottom}` +
        `- swpPaddingBottom-${this.swiperPaddingBottom}`);
      return;
    }

    if (ts === SCBFoldedState.HALF_FOLDED && cs === SCBFoldedState.HALF_FOLDED_PHYSICAL_KEYBOARD) {
      this.acFirstGridPaddingBottom = singleGridSpace - gTop + this.acGridPaddingBottom;
      this.acSecondGridPaddingTop = Math.abs(gTop + gSpace - singleGridSpace) + this.acGridPaddingTop;
      this.acSecondGridPaddingBottom = gBottom + this.acGridPaddingBottom;
      this.swiperPaddingBottom = 0;
      log.showInfo(`rgp2 firstPadding[top,bottom]=${this.acFirstGridPaddingTop},${this.acFirstGridPaddingBottom} ` +
        `- secondPadding[top,bottom]=${this.acSecondGridPaddingTop},${this.acSecondGridPaddingBottom}` +
        `- swpPaddingBottom-${this.swiperPaddingBottom}`);
      return;
    }

    if (ts === SCBFoldedState.UNFOLDED_HORIZONTAL && cs === SCBFoldedState.UNFOLDED_VERTICAL) {
      this.acFirstGridPaddingBottom = this.acGridPaddingBottom;
      this.acSecondGridPaddingTop = this.acGridPaddingTop;
      this.acSecondGridPaddingBottom = gBottom + this.acGridPaddingBottom;
      this.swiperPaddingBottom = 0;
      log.showInfo(`rgp3 firstPadding[top,bottom]=${this.acFirstGridPaddingTop},${this.acFirstGridPaddingBottom} ` +
        `- secondPadding[top,bottom]=${this.acSecondGridPaddingTop},${this.acSecondGridPaddingBottom}` +
        `- swpPaddingBottom-${this.swiperPaddingBottom}`);
      return;
    }
    if (ts === SCBFoldedState.UNFOLDED_VERTICAL && cs === SCBFoldedState.UNFOLDED_HORIZONTAL) {
      this.acFirstGridPaddingBottom = this.acGridPaddingBottom;
      this.acSecondGridPaddingTop = this.acGridPaddingTop;
      this.acSecondGridPaddingBottom = gTop + this.acGridPaddingBottom;
      this.swiperPaddingBottom = Math.abs(gBottom - gTop);
      log.showInfo(`rgp4 firstPadding[top,bottom]=${this.acFirstGridPaddingTop},${this.acFirstGridPaddingBottom} ` +
        `- secondPadding[top,bottom]=${this.acSecondGridPaddingTop},${this.acSecondGridPaddingBottom}` +
        `- swpPaddingBottom-${this.swiperPaddingBottom}`);
      return;
    }
    this.doAnimationForFoldStateChange(cs, gTop, gBottom, gSpace, singleGridSpace, isNeedResetPaddingAnimation, ts);
  }

  private doAnimationForFoldStateChange(cs: SCBFoldedState, gTop: number, gBottom: number, gSpace: number,
    singleGridSpace: number, isNeedResetPaddingAnimation: boolean,
    ts?: SCBFoldedState): void {
    let targetState = ts;
    if (ts === undefined) {
      targetState = cs;
    }

    if (AppCenterDragMgr.getInstance().getAppCenterViewShow() && isNeedResetPaddingAnimation) {
      animateTo({
        duration: FOLD_TO_UNFOLDED_DURATION,
        curve: Curve.Friction,
      }, () => {
        this.doResetPadding(gTop, gBottom, gSpace, singleGridSpace, targetState);
      });
    } else {
      this.doResetPadding(gTop, gBottom, gSpace, singleGridSpace, targetState);
    }

    log.showInfo(`firstPadding[top,bottom]=${this.acFirstGridPaddingTop},${this.acFirstGridPaddingBottom} ` +
      `- secondPadding[top,bottom]=${this.acSecondGridPaddingTop},${this.acSecondGridPaddingBottom}`);
  }

  private doResetPadding(gTop: number, gBottom: number, gSpace: number, singleGridSpace: number,
    targetState?: SCBFoldedState): void {
    switch (targetState) {
      case SCBFoldedState.UNFOLDED_VERTICAL:
        this.acFirstGridPaddingBottom = this.acGridPaddingBottom;
        this.acSecondGridPaddingTop = this.acGridPaddingTop;
        this.acSecondGridPaddingBottom = gTop + this.acGridPaddingBottom;
        this.swiperPaddingBottom = Math.abs(gBottom - gTop);
        break;
      case SCBFoldedState.HALF_FOLDED:
        this.acFirstGridPaddingBottom = singleGridSpace - gTop + this.acGridPaddingBottom;
        this.acSecondGridPaddingTop = Math.abs(gTop + gSpace - singleGridSpace) + this.acGridPaddingTop;
        this.acSecondGridPaddingBottom = gBottom + this.acGridPaddingBottom;
        this.swiperPaddingBottom = 0;
        break;
      case SCBFoldedState.UNFOLDED_HORIZONTAL:
        this.acFirstGridPaddingBottom = this.acGridPaddingBottom;
        this.acSecondGridPaddingTop = this.acGridPaddingTop;
        this.acSecondGridPaddingBottom = gBottom + this.acGridPaddingBottom;
        this.swiperPaddingBottom = 0;
        break;
      default:
        this.acFirstGridPaddingBottom = this.acGridPaddingBottom;
        this.acSecondGridPaddingTop = gTop + this.acGridPaddingTop;
        this.acSecondGridPaddingBottom = this.acGridPaddingBottom;
        this.swiperPaddingBottom = gBottom;
        break;
    }
  }

  private getGridTopWithPageIndex(): number {
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return (this.pageIndex % 2 === 0) ? this.acFirstGridPaddingTop : this.acSecondGridPaddingTop;
    }
    return this.acGridPaddingTop;
  }

  private getGridBottomWithPageIndex(): number {
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return (this.pageIndex % 2 === 0) ? this.acFirstGridPaddingBottom : this.acSecondGridPaddingBottom;
    }
    return this.acGridPaddingBottom;
  }

  public aboutToAppear(): void {
    log.showInfo(`aboutToAppear inSearch: ${this.inSearch}-${this.pageIndex}`);
    this.onUpdatePageEvent();
    this.mLayoutVM = LayoutViewModel.getInstance();
    this.appCenterRst = this.mLayoutVM.calculateAppCenter(
      this.screenProp.screenId, false, this.screenProp.width, this.screenProp.height);
    log.showInfo(`aboutToAppear for appCenter ${this.appGridStyleConfig.mAppCenterMarginLeft}, ${this.appCenterRst.mAppCenterMarginRight},
    ${this.appGridStyleConfig.mAppCenterMarginTop}, ${this.appCenterRst.mAppCenterMarginBottom}, ${this.appGridStyleConfig.mColumnsGap}, ${this.appGridStyleConfig.mRowsGap}`);
    log.showInfo(`aboutToAppear ac-param: ${JSON.stringify(this.appCenterRst)}`);
    if (!this.inSearch) {
      this.appGridList = AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemsByPage(this.pageIndex);
      if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice() &&
      FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
        this.gridOptions = AppGridLayoutUtil.getGridLayoutOptions(
          this.appGridList, 8, this.acColumns, this.screenProp.screenId);
      } else {
        this.gridOptions = AppGridLayoutUtil.getGridLayoutOptions(
          this.appGridList, this.screenProp.screenId);
      }
    }
    this.acGridPaddingTop = this.appCenterRst?.mAppCenterMarginTop ?? 0;
    this.acGridPaddingBottom = this.appCenterRst?.mAppCenterMarginBottom ?? 0;
    this.acGridPaddingLeft = this.appCenterRst?.mAppCenterMarginLeft ?? 0;
    this.acColumns = this.appGridStyleConfig.mColumns;
    this.acRows = this.appGridStyleConfig.mRows;
    this.iconSize = this.appCenterRst?.mIconSize ?? 0;
    this.iconRadius = this.appCenterRst?.mIconRadius ?? DEFAULT_ICON_RADIUS;
    this.nameSize = this.appCenterRst?.mNameSize ?? 0;
    this.appCenterBubbleMarginTop = this.appCenterRst?.mAppCenterBubbleMarginTop ?? 0;
    this.appCenterBubbleMarginBottom = this.appCenterRst?.mAppCenterBubbleMarginBottom ?? 0;
    AppCenterDragMgr.getInstance().setIconRadius(this.iconRadius);
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      localEventManager.registerEventListener(this.foldStateChangeListener,
        [FoldedDeviceAcViewModel.FOLD_STATE_CHANGE_EVT_NAME]);
      this.acGridPaddingTop = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getAcGridPaddingTop();
      this.acGridPaddingBottom = this.acGridPaddingTop;
      if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
        this.acColumns = this.appGridStyleConfig.mColumns;
        this.acRows = this.appGridStyleConfig.mRows;
      }
      this.mIconNameMargin = StyleConstants.DEFAULT_14;
      this.acFirstGridPaddingTop =
        AppCenterViewModel.getInstance().getAppGridStyleConfig(this.screenProp.screenId)
          .mAppCenterMarginTop + this.acGridPaddingTop;
      this.resetGridPadding(FoldedDeviceAcViewModel.getInstance().getCurrentFoldState(), false);
    }
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    if (FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).isFoldedDevice()) {
      AppCenterViewModel.getInstance()
        .initDynamicEffectFold(this.screenProp.screenId, this.pageIndex, this.idpAppItemPosX, this.idpRtlAppItemPosX,
          this.idpAppItemPosY, this.idpAppItemOpacity, this.appItemPosX, this.rtlAppItemPosX, this.appItemPosY,
          this.appItemOpacity, this.inSearch);
    } else {
      AppCenterViewModel.getInstance()
        .initDynamicEffect(this.screenProp.screenId, this.pageIndex, this.idpAppItemPosX, this.idpRtlAppItemPosX,
          this.idpAppItemPosY, this.idpAppItemOpacity);
    }
    AppCenterViewModel.getInstance()
      .registerDynamicEffect(this.screenProp.screenId, this.pageIndex, this.idpAppItemPosX, this.idpRtlAppItemPosX,
        this.idpAppItemPosY, this.idpAppItemOpacity, this.inSearch);

    if (this.pageIndex === 0 && !this.inSearch) {
      // 超过5页数据则执行预加载逻辑
      AppCenterViewModel.getInstance().startPreloadSwiperPages(this.screenProp.screenId);
    }
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (this.screenProp.screenId !== screenProperty.screenId) {
      log.showInfo(`screen id not equal: ${this.screenProp.screenId} ${screenProperty.screenId}`);
      return;
    }
    if (this.currentScreenHeight === screenProperty.height &&
      this.currentScreenWidth === screenProperty.width) {
      log.showInfo('screen width or height not change');
      return;
    }
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      log.showInfo('fold device');
      return;
    }
    if (!this.mLayoutVM) {
      this.mLayoutVM = LayoutViewModel.getInstance();
    }
    this.appCenterRst = this.mLayoutVM.calculateAppCenter(
      this.screenProp.screenId, false, screenProperty.width, screenProperty.height);
    log.showInfo(`aboutToAppear for appCenter ${this.appGridStyleConfig.mAppCenterMarginLeft}, ${this.appCenterRst.mAppCenterMarginRight},
    ${this.appGridStyleConfig.mAppCenterMarginTop}, ${this.appCenterRst.mAppCenterMarginBottom}, ${this.appGridStyleConfig.mColumnsGap}, ${this.appGridStyleConfig.mRowsGap}`);
    log.showInfo(`aboutToAppear ac-param: ${JSON.stringify(this.appCenterRst)}`);
    if (!this.inSearch) {
      this.appGridList = AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemsByPage(this.pageIndex);
      this.gridOptions = AppGridLayoutUtil.getGridLayoutOptions(this.appGridList, this.screenProp.screenId);
    }
    this.acGridPaddingTop = this.appCenterRst?.mAppCenterMarginTop ?? 0;
    this.acGridPaddingBottom = this.appCenterRst?.mAppCenterMarginBottom ?? 0;
    this.acGridPaddingLeft = this.appCenterRst?.mAppCenterMarginLeft ?? 0;
    this.acColumns = this.appGridStyleConfig.mColumns;
    this.acRows = this.appGridStyleConfig.mRows;
    this.currentScreenHeight = screenProperty.height;
    this.currentScreenWidth = screenProperty.width;
    this.iconSize = this.appCenterRst?.mIconSize ?? 0;
    this.iconRadius = this.appCenterRst?.mIconRadius ?? DEFAULT_ICON_RADIUS;
    this.nameSize = this.appCenterRst?.mNameSize ?? 0;
    AppCenterDragMgr.getInstance().setIconRadius(this.iconRadius);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear inSearch: ${this.inSearch}-${this.pageIndex}`);
    this.offUpdatePageEvent();
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      localEventManager.unregisterEventListener(this.foldStateChangeListener);
    }
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    AppCenterViewModel.getInstance().unregisterDynamicEffect(this.screenProp.screenId, this.pageIndex, this.inSearch);
  }

  private updateAppGridList(): void {
    log.showInfo(`updateAppGridList: ${this.appGridList.length}`);
  }

  private onUpdatePageEvent(): void {
    log.showInfo('onUpdatePageEvent pageIndex:' + this.pageIndex);
    this.desktopContext?.eventHub.on(FeatureConstants.EVENT_UPDATE_CURRENT_PAGE, this.updateCurrentPageCallBack);
    this.desktopContext?.eventHub.on(FeatureConstants.EVENT_UPDATE_GRID_OPTIONS, this.updateGridOptionCallBack);
    this.desktopContext?.eventHub.on(AppCenterDragMgr.getInstance().getDragRefreshPageEventKey(this.pageIndex),
      this.updateCurrentPageEventFromDrag);
  }

  private offUpdatePageEvent(): void {
    log.showInfo('offUpdatePageEvent pageIndex:' + this.pageIndex);
    this.desktopContext?.eventHub.off(FeatureConstants.EVENT_UPDATE_CURRENT_PAGE, this.updateCurrentPageCallBack);
    this.desktopContext?.eventHub.off(FeatureConstants.EVENT_UPDATE_GRID_OPTIONS, this.updateGridOptionCallBack);
    this.desktopContext?.eventHub.off(AppCenterDragMgr.getInstance().getDragRefreshPageEventKey(this.pageIndex),
      this.updateCurrentPageEventFromDrag);
  }

  private updateCurrentPageEvent(): void {
    // 搜索时，在后端安装应用之后，不进行搜索页面刷新
    if (this.inSearch) {
      return;
    }
    this.appGridList = AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemsByPage(this.pageIndex);
    log.showInfo(`updateCurrentPageEvent, page: ${this.pageIndex}, appGridList.length: ${this.appGridList.length}`);
    this.gridOptions = AppGridLayoutUtil.getGridLayoutOptions(this.appGridList, this.screenProp.screenId);
    this.appGridList?.forEach((item: AppItemInfo, index: number) => {
      log.showInfo(`updateCurrentPageEvent: ${index}-${AppGridLayoutUtil.appGridItemToString(item)}, moduleName: ${item?.moduleName}, bundleName: ${item?.bundleName}`);
    });
  }

  private updateCurrentPageEventFromDrag: Function = () => {
    animateTo({
      duration: AC_DRAG_SQUEEZE_DURATION,
      curve: curves.interpolatingSpring(0.5, 1, 228, 30)
    }, () => {
      this.appGridList = AppCenterDragMgr.getInstance().getAppGridListByPage(this.pageIndex);
    });
    log.showInfo(`updateCurrentPageEventFromDrag, page: ${this.pageIndex}, appGridList.length: ${this.appGridList.length}`);
    this.gridOptions = AppGridLayoutUtil.getGridLayoutOptions(this.appGridList, this.screenProp.screenId);
    this.appGridList?.forEach((item: AppItemInfo, index: number) => {
      log.showInfo(`updateCurrentPageEventFromDrag: ${index}-${AppGridLayoutUtil.appGridItemToString(item)}, moduleName: ${item?.moduleName}, bundleName: ${item?.bundleName}`);
    });
  };

  private updateGridOptionEvent(): void {
    log.showInfo('updateGridOptionEvent');
    this.gridOptions = AppGridLayoutUtil.getGridLayoutOptions(this.appGridList, this.screenProp.screenId);
  }

  private itemDragStart(): void {
    log.showInfo('itemDragStart');
    this.isDragFlag = true;
    this.dragStart?.();
  }

  private itemDragEnd(): void {
    log.showInfo('itemDragEnd');
    this.isDragFlag = false;
    this.dragEnd?.();
  }

  private getColumnsTemplate() {
    let columnsTemplate = '';
    for (let i = 0; i < this.acColumns; i++) {
      columnsTemplate += ' 1fr';
    }
    return columnsTemplate;
  }

  private getRowsTemplate() {
    let rowsTemplate = '';
    if (this.isScroll) {
      return rowsTemplate;
    }
    for (let i = 0; i < this.acRows; i++) {
      rowsTemplate += ' 1fr';
    }
    return rowsTemplate;
  }



  /**
   * 退出应用中心，带动效
   *
   *
   * @param scene
   */
  private doHideAppCenterWithAnimation(scene?: string, screenId?: number) {
    log.showInfo(`doHideAppCenterWithAnimation screenId: ${screenId}`)
    if (!(GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation'))) {
      return;
    }
    if (!this.isGainFocus) {
      return;
    }
    log.showInfo(`${scene} hide AppCenterWithAnimation from :${TAG}`);

    // 执行应用中心隐藏
    let hideAppCenterWithAnimation = (GlobalContext.getInstance()
      .getObject('hideAppCenterWithAnimation')) as Function;
    hideAppCenterWithAnimation(screenId);

    // 顺带对任务中心补充隐藏
    windowManager.hideWindow(windowManager.RECENT_WINDOW_NAME);
  }

  /**
   * 处理鼠标事件
   *
   * @param event
   */
  private handleMouseEvent(event?: MouseEvent): void {
    if (event?.button === MouseButton.Right) {
      event.stopPropagation?.();
    }
  }

  private getForEachKey(item: AppItemInfo) {
    if (!item) {
      return 'AppGrid';
    }
    let key: string =
      `AppGrid_${item.appName}${item.bundleName}${item.moduleName}${item.abilityName}${item.badgeNumber}${item.page}${item.appStatus}${item.appIndex}${item.isUninstallAble}${item.appLabelId}${item.appIconId}`;
    return key;
  }

  @Styles
  normalStyles() {
    .border({
      width: 0,
      color: '#00000000',
    })
    .backgroundColor(Color.Transparent)
  }

  @Styles
  focusedStyles() {
    .border({
      width: this.appGridStyleConfig.mAppCenterBorderWidth,
      radius: $r('sys.float.ohos_id_corner_radius_default_l'),
      color: $r('sys.color.ohos_id_color_focused_outline')
    })
    .backgroundColor($r('sys.color.ohos_id_color_component_normal'))
  }

  private getIndex(item: AppItemInfo): number {
    const index: number = this.appGridList.findIndex(
      (i) => i.bundleName === item.bundleName && i.appIndex === item.appIndex);
    if (index === -1) {
      log.showError(`cant find item: ${item.bundleName}`);
      return 0;
    }
    return index;
  }

  private getTranslateIndex(item: AppItemInfo, pageIdx: number): number {
    const index: number = this.getIndex(item);

    if (!FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return index;
    }
    let cs: SCBFoldedState = FoldedDeviceAcViewModel.getInstance().getCurrentFoldState();
    if (cs === SCBFoldedState.UNFOLDED_VERTICAL ||
      cs === SCBFoldedState.UNFOLDED_HORIZONTAL) {

      // 计算hopper展开态时，第二屏数据角标为：第一页满屏数+当前所在数组角标
      return pageIdx % 2 === 0 ? index : index + this.acRows * this.acColumns;
    }
    return index;
  }

  private onIconContainerClickCallback = (event?: ClickEvent) => {
    log.showInfo('onIconContainerClickCallback');
    if (this.isDragFlag) {
      log.showInfo('in drag, not response');
      return;
    }
    this.doHideAppCenterWithAnimation('AppBubble');
  }

  private getNextFocus(index?: number): FocusMovement | undefined {
    if (!FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return undefined;
    }
    let nextFocus: FocusMovement = {
      forward: CommonConstants.APP_CENTER_REQUEST_FOCUS_KEY + `${this.pageIndex + 1}`
    };
    return (this.appGridList.length - 1 === index) ?
      nextFocus : undefined;
  }

  @Builder
  buildGridItem(item: AppItemInfo, index?: number) {
    GridItem() {
      AppCenterItem({
        item: item,
        isDragStart: this.isDragStart,
        appGridStyleConfig: this.appGridStyleConfig,
        enableBadge: this.enableBadge,
        buildMenu: this.buildMenu,
        notInstalledMenuMap: this.buildNotInstalledAppMenu,
        traceId: this.traceId,
        onItemClick: this.onItemClick,
        getIndexInSwiper: this.getIndexInSwiper,
        dragAllowed: !this.inSearch && this.dragAllowed,
        itemDragStart: () => this.itemDragStart(),
        itemDragEnd: () => this.itemDragEnd(),
        appCenterBubbleMarginTop: this.appCenterBubbleMarginTop,
        appCenterBubbleMarginBottom: this.appCenterBubbleMarginBottom,
        iconSize: this.iconSize,
        onIconContainerClick: this.onIconContainerClickCallback,
        screenProp: this.screenProp,
        iconRadius: this.iconRadius,
        nameSize: this.nameSize,
        mIconNameMargin: this.mIconNameMargin,
        pageIndex: this.pageIndex,
        acColumns: this.acColumns,
      })
    }
    .id(`${TAG}_gridItem_${index}`)
    .key(this.getIndex(item) === 0 ? CommonConstants.APP_CENTER_REQUEST_FOCUS_KEY + this.pageIndex : '')
    .nextFocus(this.getNextFocus(this.getIndex(item)))
    .width(this.appGridStyleConfig.mAppCenterItemWidth)
    .height(this.appGridStyleConfig.mAppCenterItemHeight)
    .translate({
      x: RTLUtil.isRTL() ? this.idpRtlAppItemPosX[this.getTranslateIndex(item, this.pageIndex)]
        : this.idpAppItemPosX[this.getTranslateIndex(item, this.pageIndex)],
      y: this.idpAppItemPosY[this.getTranslateIndex(item, this.pageIndex)]
    })
    .opacity(this.idpAppItemOpacity[this.getTranslateIndex(item, this.pageIndex)])
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
    .transition({ scale: { x: 0.5, y: 0.5 }, opacity: 0 })
  }

  build() {
    Grid(undefined, this.gridOptions) {
      /**
       * ForEach如果itemGenerator定义了index，KeyGenerator未定义index，key = KeyGenerator返回值 + index
       * 如果itemGenerator、keyGenerator都定义了index，key = keyGenerator返回值
       * 所以不要删掉keyGenerator的index，否则会导致拖拽场景下Item重新渲染
       */
      ForEach(this.appGridList, (item: AppItemInfo, index?: number) => {
        this.buildGridItem(item, index)
      }, (item: AppItemInfo, index: number) => this.getForEachKey(item))
    }
    .id(`Grid_${this.pageIndex}`)
    .animation({ duration: 200 })
    .columnsTemplate(this.getColumnsTemplate())
    .rowsTemplate(this.getRowsTemplate())
    .columnsGap(this.appGridStyleConfig.mColumnsGap)
    .rowsGap(this.appGridStyleConfig.mRowsGap)
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .onClick(() => {
      performanceMonitor.begin(HiSysEventUtil.EXIT_APP_CENTER, performanceMonitor.ActionType.LAST_UP);
      log.showInfo(`appgrid onclick :${this.isDragFlag}`);
      if (this.isDragFlag) {
        return;
      }
      this.doHideAppCenterWithAnimation('AC AppGrid', this.screenProp.screenId);
    })
    .padding({
      left: px2vp(Math.round(vp2px(this.acGridPaddingLeft ?? 0))),
      top: px2vp(Math.round(vp2px(this.getGridTopWithPageIndex()))),
      right: px2vp(Math.round(vp2px(this.acGridPaddingLeft ?? 0))),
      bottom: px2vp(Math.round(vp2px(this.getGridBottomWithPageIndex())))
    })
  }
}