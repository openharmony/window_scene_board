/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
  BaseCloseAppHandler,
  CloseAppManager,
  CommonConstants,
  EditModeConstants,
  EditModeUtils,
  EventConstants,
  GridLayoutUtil,
  LayoutViewModel,
  SettingsModel,
  StyleConstants,
  vibratorMgr,
  PageDesktopViewModelForPC,
  editModeManager
} from '@ohos/launchercommon';
import { PageDesktopViewModel } from '../common/viewmodel/PageDesktopViewModel';
import { PageDesktopDragHandler } from '../common/PageDesktopDragHandler';
import GridSwiper from '../common/components/GridSwiper';
import { PageDesktopCloseAppHandler } from '../common/PageDesktopCloseAppHandler';
import { PageDesktopCloseAppHandlerForPC } from '../common/PageDesktopCloseAppHandlerForPC';
import { DragGridPosition } from '@ohos/componentdrag';
import { launcherStatusUtil, SCBSceneSessionManager } from '@ohos/windowscene';
import { LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import {
  AccessibilityManager,
  DeviceHelper,
  GlobalContext,
} from '@ohos/frameworkwrapper';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import RightMenu from '@ohos/launchercommon/src/main/ets/pagedesktop/components/RightMenu';
import { RightMenuViewModel } from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/RightMenuViewModel';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { editModeViewManager } from '@ohos/desktopedit/src/main/ets/default/manager/EditModeViewManager';
import { FocusViewModel } from '../common/viewmodel/FocusViewModel';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import IndicatorConstants from '../common/constants/IndicatorConstants';
import display from '@ohos.display';
import { InteractiveType, themeWallpaperAniMgr } from '@ohos/themeservice';
import { DisplayCountViewModel, pageEditManager } from '@ohos/launchercommon/Index';
import { NumberConstants } from '@ohos/commonconstants';
import { SwiperLoadData } from '@ohos/swiperdata';
import {  BaseQuitAppRect } from '../common/viewmodel/QuitAppRectViewModel';

const TAG = 'PageDesktopLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const RIGHT_MENU_KEY = 'h2_launcher_feature_pagedesktop_rightMenu';

@Component
export struct PageDesktopLayout {
  @Prop singleContext?: SingleContext;
  @StorageLink('workSpaceWidth') @Watch('updateDeskTopParams') workSpaceWidth: number = 0;
  @StorageLink('workSpaceHeight') @Watch('updateDeskTopParams') workSpaceHeight: number = 0;
  @Prop device: string = 'phone';
  @Prop screenId: number | undefined;
  @State @Watch('updateDeskTopParams') mMargin: number = 0;
  @State mTop: number = 0;
  @State @Watch('changeGridConfig') gridConfig: string = '';
  @State scaleCenterY: number = 1;
  private mPageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
  private mSettingsModel: SettingsModel = SettingsModel.getInstance();
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private mBaseCloseAppHandler: BaseCloseAppHandler = PageDesktopCloseAppHandler.getInstance(this.singleContext);
  private isPad: boolean = false;
  private isSuperFold: boolean = false;
  private isDesktopLayout: boolean = true;
  private rightMenuViewModel: RightMenuViewModel = singleManager.get<RightMenuViewModel>(RightMenuViewModel, this.singleContext);
  private onDesktopModeChangeEvent: Function = (): void => this.updateDeskTopParams();
  private onDesktopDisplayChangeEvent: Function = (): void => this.updateDeskTopParams();
  private onEditModeAnimationFinishEvent: Function = (): void => this.updateDeskTopParamsEditMode();
  private onDesktopModeLayoutChangeEvent: Function = (): void => this.calculateScaleCenterY();
  private mFocusViewModel: FocusViewModel = FocusViewModel.getInstance();
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  private focusViewModelKey:string = FocusViewModel.DEFAULT_FOCUS;
  private rightClickPosition: DragGridPosition = {column: -1, row: -1, page: 0};
  @StorageLink('isPortrait') @Watch('changeGridConfig') isPortrait: boolean = true;
  @State clickMenuOffset: Position = {x: 0, y: 0};
  @State longPressMenuOffset: Position = {x: 0, y: 0};
  private touchPostion?: Position;

  onLanguageChange(): void {
    log.showInfo('onLanguageChange');
    this.rightMenuViewModel.languageChangeRefresh();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear start');
    this.mPageDesktopDragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
    this.mSettingsModel = SettingsModel.getInstance();
    this.mPageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
    this.mPageDesktopViewModel.setUIContext(this.getUIContext());
    PageDesktopViewModelForPC.getInstance().setRightMenuViewModel(this.rightMenuViewModel);
    this.gridConfig = this.mPageDesktopViewModel.getGridConfig().layout;
    this.isSuperFold = DeviceHelper.isSuperFoldMachine();
    this.updateStyle();
    this.mPageDesktopViewModel.registerAppListChangeCallback();
    if (this.device !== CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.mBaseCloseAppHandler = PageDesktopCloseAppHandlerForPC.getInstance(this.singleContext);
    } else {
      this.mBaseCloseAppHandler = PageDesktopCloseAppHandler.getInstance(this.singleContext);
    }
    CloseAppManager.getInstance().registerCloseAppHandler(this.mBaseCloseAppHandler);
    AccessibilityManager.getInstance().initAccessibilityModeListener();
    this.registerScreenIdChange();
    let desktopContext: ServiceExtensionContext = GlobalContext.getContext();
    desktopContext.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    desktopContext.eventHub.on(EventConstants.EVENT_SUPER_FOLD_STATUS_CHANGE, this.onDesktopModeChangeEvent);
    desktopContext.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_DISPLAY_COUNT, this.onDesktopDisplayChangeEvent);
    desktopContext.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE_LAYOUT, this.onDesktopModeLayoutChangeEvent);
    desktopContext.eventHub.on(EventConstants.EVENT_CHANGE_ENTER_EDIT_MODE_ANIMATION_FINISH,
      this.onEditModeAnimationFinishEvent);
    this.mFocusViewModel.registerFocusEventListener(this.focusViewModelKey, this);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear start');
    CloseAppManager.getInstance().unregisterCloseAppHandler(this.mBaseCloseAppHandler);
    let desktopContext: ServiceExtensionContext = GlobalContext.getContext();
     desktopContext.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    desktopContext.eventHub.off(EventConstants.EVENT_SUPER_FOLD_STATUS_CHANGE, this.onDesktopModeChangeEvent);
    desktopContext.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_DISPLAY_COUNT, this.onDesktopDisplayChangeEvent);
    desktopContext.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE_LAYOUT, this.onDesktopModeLayoutChangeEvent);
    desktopContext.eventHub.off(EventConstants.EVENT_CHANGE_ENTER_EDIT_MODE_ANIMATION_FINISH,
      this.onEditModeAnimationFinishEvent);
    this.mFocusViewModel.unregisterFocusEventListener(this.focusViewModelKey, this);
    this.unRegisterScreenIdChange();
  }

  onFocusedEvent(isFocused: boolean): void {
    log.showDebug('onFocusedEvent');
    focusControl.requestFocus(this.focusViewModelKey);
  }

  private updateStyle(): void {
    this.mPageDesktopViewModel.setDevice(this.device);
    this.isPad = this.mPageDesktopViewModel.getDevice();
    log.showInfo(`updateStyle isPad: ${this.isPad}`);
  }

  private checkPageDesktopDragHandlerIsNull(): void {
    if (this.mPageDesktopDragHandler != null) {
      this.mPageDesktopDragHandler.setDragEffectArea({
        left: this.mMargin,
        top: this.mTop,
        right: this.workSpaceWidth - this.mMargin,
        bottom: (PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig().mGridHeight as number) + this.mTop
      });
    }
  }

  private updateDeskTopParams(): void {
    log.showInfo('start updateDeskTopParams')
    if (!launcherStatusUtil.isCurrentDesktopVisible(false)) {
      log.showInfo('isCurrentDesktopVisible end')
      return;
    }
    let config = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig();
    //在更新网格布局参数之前，重新计算一下相关参数，
    config.initConfig();
    this.mMargin = DeviceHelper.isSuperFoldMachine() ? (config.mWorkSpacePadding as number) : this.mMargin;
    this.mTop = config.mDesktopMarginTop;
    if (this.isSuperFold) {
      this.mTop = this.mTop === 0 ? config.mWorkSpacePaddingTop : this.mTop;
    }
    this.checkPageDesktopDragHandlerIsNull();
    let gridConfig = PageDesktopViewModel.getInstance(this.singleContext).getGridConfig();
    let sysUITop: number = LayoutViewModel.getInstance().getSysUITopHeight();
    this.updateGridParams(config, gridConfig.row, gridConfig.column, sysUITop);
    // 通知退出落位重新计算
    log.showInfo(`swiperpage change config:${JSON.stringify(config)}; gridConfig:${JSON.stringify(gridConfig)};`)
    BaseQuitAppRect.getInstance().initGridParamDesktop(config, gridConfig);
  }

  updateDeskTopParamsEditMode(): void {
    if (editModeManager.isInNormalMode()) {
      return;
    }
    if (!launcherStatusUtil.isCurrentDesktopVisible(false)) {
      return;
    }
    const coordinates = this.getEditModeGridLayout();
    if (coordinates[0].length === 0 || (coordinates.length > 1 && coordinates[1].length === 0)) {
      // 通过id获取坐标失败、return
      return;
    }
    pageEditManager.editModeDragAnimatePageData.dragGridImageTopY = coordinates[0][1];
    let oriCoordinates = EditModeUtils.getCoordinates();
    // 如果在获取rect参数时滑动了grid、获取的left会有偏差、因此左边界还是采用计算值
    const currentDisplayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    for (let i = 0; i < currentDisplayCount; i++) {
      coordinates[i][0] = oriCoordinates[i][0];
    }
    EditModeUtils.setCoordinateParameters(coordinates);
    let config = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig();
    let gridConfig = PageDesktopViewModel.getInstance(this.singleContext).getGridConfig();
    let centerY = GridLayoutUtil.getFloorVp(config.mItemPadding) + GridLayoutUtil.getFloorVp(config.mIconSize) / 2 +
      (DeviceHelper.isPhone() ? 0 : GridLayoutUtil.getFloorVp(config.mIconMarginVertical));
    let paddings: number[] = [];
    for (let i = 0; i < currentDisplayCount; i++) {
      paddings.push(coordinates[i]?.[0] ?? coordinates[0][0]);
    }
    GridLayoutUtil.updateEditModeGridPosition({
      paddingLeft: coordinates[0][0],
      paddingTop: coordinates[0][1],
      row: gridConfig.row,
      column: gridConfig.column,
      rowGap: config.mRowsGap,
      columnGap: config.mColumnsGap,
      gridWidth: coordinates[0][2],
      gridHeight: coordinates[0][3],
    }, paddings, undefined, centerY * EditModeUtils.getDesktopScale());
  }

  private getEditModePaddingTop(paddingTop: number, sysUITop: number, swiperScale: number, pageScale: number,): number {
    // 涉及边距或间距相关计算时使用向下取整，当涉及高度相关计算时使用四舍五入
    let workSpaceHeight: number = GridLayoutUtil.getRoundVp(AppStorage.get<number>('workSpaceHeight') as number);
    let sysUIPaddingTop: number = GridLayoutUtil.getFloorVp(sysUITop);
    let gridPaddingTop: number = GridLayoutUtil.getFloorVp(paddingTop);
    let centerY = (workSpaceHeight - sysUIPaddingTop) / 2 + sysUIPaddingTop;
    // 第一次缩放
    const firstGridY = gridPaddingTop + GridLayoutUtil.getRoundVp(
      (GridLayoutUtil.getRoundVp(this.scaleCenterY) - gridPaddingTop + sysUIPaddingTop) * (1 - swiperScale));
    centerY = centerY + GridLayoutUtil.getRoundVp(
      (GridLayoutUtil.getRoundVp(this.scaleCenterY) - centerY + sysUIPaddingTop) * (1 - swiperScale));
    // 计算高度时四舍五入, 扩展新形态小折叠产品外屏需要减掉1.3vp左右适配图标背板偏移量
    let adjustHeight = false ? 1.3 : 0;
    // 第二次缩放
    return firstGridY + GridLayoutUtil.getRoundVp((centerY - firstGridY) * (1 - pageScale)) - adjustHeight;
  }

  private updateGridParams(config: PageDesktopGridStyleConfig, row: number, column: number, sysUITop: number): void {
    let paddingLeft = config.realPaddingLeft ?? (config.mMargin + config.mScreenPadding);
    let paddingTop = config.mDesktopMarginTop + config.mScreenPaddingTop;
    // 桌面布局中Swiper组件的上间距为sysUITop，Grid组件的上间距为paddingTop - sysUITop，需要分开进行像素向下取整
    let updateTop = GridLayoutUtil.getFloorVp(sysUITop) + GridLayoutUtil.getFloorVp(paddingTop - sysUITop);
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      updateTop -= CommonConstants.OUTER_SCREEN_OFFSET;
    }
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let centerY = GridLayoutUtil.getFloorVp(config.mItemPadding) + GridLayoutUtil.getFloorVp(config.mIconSize) / 2 +
      (DeviceHelper.isPhone() ? 0 : GridLayoutUtil.getFloorVp(config.mIconMarginVertical));
    let gridWidth = config.mGridWidth;
    let gridHeight = config.mGridHeight;
    // config.mFoldPaddingSide 可能为undefined
    let paddings: number[] = [];
    const currentDisplayCount: number = DisplayCountViewModel.getInstance().getDisplayCount();
    for (let i = 0; i < currentDisplayCount; i++) {
      if (i < Math.floor(currentDisplayCount / 2)) {
        paddings.push(screenWidth / currentDisplayCount * i + paddingLeft + (config.mFoldPaddingSide ?? 0));
      } else if (i > Math.floor(currentDisplayCount / 2)) {
        paddings.push(screenWidth / currentDisplayCount * i + paddingLeft - (config.mFoldPaddingSide ?? 0));
      } else {
        paddings.push(screenWidth / currentDisplayCount * i + paddingLeft);
      }
    }
    log.showInfo(`updateGridParams screenWidth ${screenWidth} paddings ${paddings} currentDisplayCount ${currentDisplayCount} mFoldPaddingSide ${config.mFoldPaddingSide}`);
    if (DeviceHelper.isSuperFoldMachine()) {
      const extraHeight: number = config.mWorkSpacePaddingTop + config.mDesktopMarginTop;
      if (this.isPortrait) {
        try {
          const foldStatus = display.getFoldStatus();
          const isExpandStatus: boolean = foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED;
          paddings = isExpandStatus ?
            [extraHeight, extraHeight + gridHeight] :
            [extraHeight, extraHeight + gridHeight + config.mFoldCreaseRegionHeight];
        } catch (error) {
          log.showError(`layout get foldStatus fail message ${error?.message}, code ${error?.code}`);
        }
      } else {
        paddings = [config.mWorkSpacePadding, config.mWorkSpacePadding + gridWidth];
      }
      paddingLeft = config.mWorkSpacePadding;
      updateTop = extraHeight;
    }
    GridLayoutUtil.initGridPosition({
      paddingLeft: paddingLeft,
      paddingTop: config.realPaddingTop ?? updateTop,
      row: row,
      column: column,
      rowGap: config.mRowsGap,
      columnGap: config.mColumnsGap,
      gridWidth: gridWidth,
      gridHeight: gridHeight,
    }, paddings, screenWidth, undefined, centerY);
    if (editModeManager.isInEditMode()) {
      this.calculateScaleCenterY();
      const swiperScale = editModeViewManager.getEditModeGridSwiperViewData().getGridSwiperScale();
      const pageScale = editModeViewManager.getEditModeSingePageViewData().getSingePageSwiperScale();
      const mergedScale = swiperScale * pageScale;
      updateTop = this.getEditModePaddingTop(paddingTop, sysUITop, swiperScale, pageScale);
      paddingLeft += gridWidth * (1 - mergedScale) / 2;
      gridWidth *= mergedScale;
      gridHeight *= mergedScale;
      const coordinates = [[paddingLeft, GridLayoutUtil.getFloorVp(updateTop), gridWidth, gridHeight]];
      pageEditManager.editModeDragAnimatePageData.dragGridImageTopY = coordinates[0][1];
      if (desktopUtil.isFoldExpandStatus()) {
        const editPaddingLeft = (config.mMargin + config.mScreenPadding) * mergedScale;
        const editLeft = screenWidth * (1 - mergedScale) / 2;
        coordinates[0][0] = paddings[0] = editLeft + editPaddingLeft + (config.mFoldPaddingSide ?? 0) * mergedScale;
        for (let i = 1; i < currentDisplayCount; i++) {
          if (i < Math.floor(currentDisplayCount / 2)) {
            paddings[i] = editLeft + (screenWidth * mergedScale / currentDisplayCount) * i + editPaddingLeft +
              (config.mFoldPaddingSide ?? 0) * mergedScale;
          } else if (i > Math.floor(currentDisplayCount / 2)) {
            paddings[i] = editLeft + (screenWidth * mergedScale / currentDisplayCount) * i + editPaddingLeft -
              (config.mFoldPaddingSide ?? 0) * mergedScale;
          } else {
            paddings[i] = editLeft + (screenWidth * mergedScale / currentDisplayCount) * i + editPaddingLeft;
          }
          coordinates.push([paddings[i], GridLayoutUtil.getFloorVp(updateTop), gridWidth, gridHeight]);
        }
      }
      EditModeUtils.setCoordinateParameters(coordinates);
      GridLayoutUtil.updateEditModeGridPosition({
        paddingLeft: paddingLeft,
        paddingTop: updateTop,
        row: row,
        column: column,
        rowGap: config.mRowsGap,
        columnGap: config.mColumnsGap,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
      }, paddings, undefined, centerY * mergedScale);
    }
    log.showInfo(`updateGridParams paddingLeft = ${paddingLeft}, paddings = ${paddings} gridWidth ${gridWidth}`);
  }

  /**
   * 获取grid布局
   * @param page
   * @returns [left: number, top: number, width: number, height: number]
   */
  private getGridInspectorByPage(page: number): number[] {
    // 自己手动计算有误差、这里使用getInspectorByKey获取rect参数
    let key = false ? `${CommonConstants.SWIPER_GRID_WORKSPACE_TAG}${page}_OuterDesktop` :
      `${CommonConstants.SWIPER_GRID_WORKSPACE_TAG}${page}`;
    log.showInfo(`editMode compute gridId = ${key}`);
    try {
      let rectJson = getInspectorByKey(key);
      let obj:Record<string, string> = JSON.parse(rectJson);
      let rectInfo:string[] = JSON.parse('[' + obj.$rect + ']');
      let left: number = px2vp(Number(JSON.parse('[' + rectInfo[0] + ']')[0]));
      let top: number = px2vp(Number(JSON.parse('[' + rectInfo[0] + ']')[1]));
      let right: number = px2vp(Number(JSON.parse('[' + rectInfo[1] + ']')[0]));
      let bottom: number = px2vp(Number(JSON.parse('[' + rectInfo[1] + ']')[1]));
      if (false && right === left && bottom === top) {
        log.showError(`outer editMode getGridInspectorByPage error, ${rectInfo}`);
      }
      return [left, top, right - left, bottom - top];
    } catch (e) {
      log.showInfo(`getGridInspectorByPage fail :${e.code}}: ${e.message}}`);
      return []
    }
  }

  private getEditModeGridLayout(): number[][] {
    let page = AppStorage.get<number>(desktopUtil.getPageIndex()) as number;
    const pages: number[] = SwiperLoadData.getInstance().getPages();
    if (page >= pages.length) {
      // 加号页宫格布局与正常桌面不一致，需要进行隔离，避免进入编辑模式时快速翻到加号页导致获取到的编辑模式布局参数异常
      page = pages.length - 1;
    }
    const layout: number[][] = [this.getGridInspectorByPage(page)];
    // 折叠屏 展开态
    const currentDisplayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    for (let i = 1; i < currentDisplayCount; i++) {
      layout.push(this.getGridInspectorByPage(page + i));
    }
    if (RTLUtil.isRTL()) {
      layout.reverse();
    }
    return layout;
  }

  calculateScaleCenterY(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(false)) {
      return;
    }
    let workSpaceHeight = AppStorage.get<number>('workSpaceHeight') as number;
    let statusHeight = LayoutViewModel.getInstance().getSysUITopHeight();
    let swiperHeight = workSpaceHeight - statusHeight;
    if (!DeviceHelper.isPhone()) {
      let screenHeight = AppStorage.get<number>('screenHeight') as number;
      swiperHeight = swiperHeight * (screenHeight - StyleConstants.SMART_DOCK_MARGIN_TOP) / screenHeight;
    }
    let config = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig();
    let marginTop: number = config.mDesktopMarginTop as number - statusHeight;
    let gridHeight: number = config.mGridHeight as number;
    let bottom: number = swiperHeight - gridHeight - marginTop;
    // 背板y轴位移高度，使grid相对背板居中
    let bgTranslateY: number = (marginTop - bottom) / 2;
    editModeViewManager.getEditModeSingePageViewData().setEditModeBgTranslateY(bgTranslateY);
    // swiper底部添加的高度
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let singlePageScale: number = EditModeUtils.calSinglePageScale(screenWidth);
    let editModeSwiperScale: number = EditModeUtils.calSwiperScale(screenWidth);
    let addHeight: number = EditModeUtils.getBackplaneAddHeight() / editModeSwiperScale / singlePageScale;
    let bottomAddHeight = addHeight / 2 + bgTranslateY;
    let pageDownHeight = (swiperHeight / 2 + bottomAddHeight) * (1 - singlePageScale) * editModeSwiperScale;
    // page底部向上缩放高度
    let scaleY: number = config.mMarginBottomOfIndicator + IndicatorConstants.HEIGHT_OF_NEGATIVE_SCREEN_INDICATOR +
      EditModeConstants.SWIPER_EDIT_BOTTOM_INDICATOR + bottomAddHeight - pageDownHeight;
    let downHeight: number = scaleY / (1 - editModeSwiperScale);
    this.scaleCenterY = swiperHeight - downHeight + bottomAddHeight;
    EditModeUtils.setScaleCenterY(this.scaleCenterY);
    log.showInfo('calculateScaleCenterY swiperHeight:%{public}d, marginBottomOfIndicator: %{public}d, scaleCenterY: ' +
      '%{public}d, scaleY:%{public}d, bgTranslateY: %{public}d, pageDownHeight: %{public}d, marginTop:%{public}d, ' +
      'gridHeight: %{public}d, statusHeight: %{public}d, bottom:%{public}d',
      swiperHeight, config.mMarginBottomOfIndicator, this.scaleCenterY, scaleY, bgTranslateY, pageDownHeight,
      marginTop, gridHeight, statusHeight, bottom);
  }

  private changeGridConfig(): void {
    log.showDebug(`changeGridConfig GridConfig: ${this.gridConfig}`);
    this.updateDeskTopParams();
  }

  private setRightClickPos(x: number, y: number): void {
    if (this.isSuperFold) {
      this.rightClickPosition = GridLayoutUtil.getRowAndColumnAndPage(x, y, this.isPortrait);
    } else {
      this.rightClickPosition = GridLayoutUtil.getRowAndColumn(x, y, 0);
      this.rightClickPosition.page = 0;
    }
  }

  /**
   *
   * @param y
   * @param eventType 事件类型，0表示mouseEvent， 1表示TouchEvent
   * @returns
   */
  private calcMenuOffsetY(event: BaseEvent): Position {
    return this.rightMenuViewModel.getMenuOffset(event, this.rightMenuViewModel.getRightMenuInfoList(), TAG);
  }

  private menuPreHandlerByMouseEvent(event: MouseEvent): void {
    if (event.button === MouseButton.Right && event.action === MouseAction.Press) {
      this.rightMenuViewModel.rightMenuShowPreHandler();
      this.clickMenuOffset = this.calcMenuOffsetY(event);
      this.touchPostion = { x: event.displayX, y: event.displayY };
      log.showInfo(`menuPreHandlerByMouseEvent ${this.clickMenuOffset.y}`);
    }
  }

  private menuPreHandlerByTouchEvent(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      this.rightMenuViewModel.rightMenuShowPreHandler();
      this.longPressMenuOffset = this.calcMenuOffsetY(event);
      this.touchPostion = { x: event.touches[0].windowX, y: event.touches[0].windowY };
      log.showInfo(`menuPreHandlerByTouchEvent ${this.longPressMenuOffset.y}`);
    }
  }

  private buildLog(): boolean {
    log.showInfo('build start');
    return true;
  }

  private screenIdChangeCallback: () => void = () => {
    log.showInfo('screen property change, start to reInit grid config');
    this.updateDeskTopParams();
  }

  private registerScreenIdChange(): void {
    GlobalContext.getContext()?.eventHub.on(EventConstants.EVENT_SCREEN_ID_CHANGE, this.screenIdChangeCallback);
  }

  private unRegisterScreenIdChange(): void {
    GlobalContext.getContext()?.eventHub.off(EventConstants.EVENT_SCREEN_ID_CHANGE, this.screenIdChangeCallback);
  }

  @Builder
  RightMenuBuilder() {
    RightMenu({
      singleContext: this.singleContext,
      rightMenuViewModel: this.rightMenuViewModel,
      rightClickPosition: this.rightClickPosition,
      touchPostion: this.touchPostion
    })
      .key(RIGHT_MENU_KEY)
  }

  @Styles
  longPressGestureStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction((event: GestureEvent) => {
            if (event?.source === SourceType.Mouse) {
              // 鼠标长按不响应震动
              log.showWarn('not response for mouse action');
              return;
            }
            log.showInfo(`LongPressGesture LONG_PRESS_VIBRATION, ${TAG}`);
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          })
      )
    )
  }

  build() {
    if (this.device == 'phone') {
      if (this.buildLog()) {
      }
      GridSwiper({
        singleContext: this.singleContext,
        gridConfig: this.gridConfig,
        mPageDesktopViewModel: this.mPageDesktopViewModel,
        scaleCenterY: this.scaleCenterY,
        screenId: this.screenId,
      });
    } else {
      if (this.buildLog()) {
      }
      Stack(this.isSuperFold ? {alignContent: Alignment.Top} : undefined) {
        GridSwiper({
          singleContext: this.singleContext,
          gridConfig: this.gridConfig,
          mPageDesktopViewModel: this.mPageDesktopViewModel,
          isDesktopLayout: this.isDesktopLayout,
          scaleCenterY: this.scaleCenterY,
          screenId: this.screenId
        })

        // 焦点仅能落在基础组件节点上。用于无图标获焦时，桌面获取焦点。
        Text()
          .defaultFocus(true)
          .focusable(true)
          .id(this.focusViewModelKey)
      }
      .height(this.isSuperFold ? '100%' : undefined)
      .onTouch((event: TouchEvent) => {
        if (event?.type === TouchType.Down) {
          const x: number = event?.touches[0]?.windowX ?? 0;
          const y: number = event?.touches[0]?.windowY ?? 0;
          this.setRightClickPos(x, y);
        }
        if (DeviceHelper.isPcNot2in1Device()) {
          themeWallpaperAniMgr.sendInteractiveEvent2Wallpaper({
            interactiveType: event.type === TouchType.Down ? InteractiveType.TOUCH_DOWN : InteractiveType.TOUCH_UP,
            x: event?.touches[0]?.windowX,
            y: event?.touches[0]?.windowY,
          });
        }
        this.menuPreHandlerByTouchEvent(event);
      })
      .onMouse((event: MouseEvent) => {
        if (event?.button === MouseButton.Right) {
          const x: number = event?.windowX ?? 0;
          const y: number = event?.windowY ?? 0;
          this.setRightClickPos(x, y);
        }
        this.menuPreHandlerByMouseEvent(event);
      })
      .bindContextMenu(this.RightMenuBuilder, ResponseType.LongPress, {
        backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
        offset: this.longPressMenuOffset
      })
      .bindContextMenu(this.RightMenuBuilder, ResponseType.RightClick, {
        backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
        offset: this.clickMenuOffset
      })
      .longPressGestureStyles()
    }
  }
}

