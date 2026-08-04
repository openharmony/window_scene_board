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

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import {
  CommonConstants,
  EditModeConstants,
  EditModeUtils,
  EventConstants,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  LayoutViewModel,
  OpenFolderStyleConfig,
  PageInfoManager,
  StyleConstants
} from '../../TsIndex';
import { EditModePageActionEnum, EditModePageStaticData } from '../data/PageEditData';
import { pageEditManager } from '../model/PageEditManager';
import { componentSnapshot, curves, Position, UIContext } from '@kit.ArkUI';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { DragingPageType, PageDragAction } from './PageDragAction';
import { dragSnapshotHelper, RTLUtil, SnapshotType, WeakObserver } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/TsIndex';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import {
  DropAnimationDestination,
  DropAnimationParam,
  DropAnimationScene
} from '@ohos/componentanimator/src/main/ets/TsIndex';
import { SwiperLoadData } from '@ohos/swiperdata/src/main/ets/service/swiperData/SwiperLoadData';
import { PageDragManager } from '../model/PageDragManager';
import { image } from '@kit.ImageKit';
import { editModeManager } from '../model/EditModeManager';
import { EditModeAccessibilityUtil } from '../utils/EditModeAccessibilityUtil';
import { DisplayCountViewModel } from '../../displaycount/DisplayCountViewModel';
import { EditModeStyleConfig } from '../data/PageEditData';

const TAG: string = 'PageEditViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PageEditViewModel {
  /** PageEditViewModel单例 */
  private static instance: PageEditViewModel;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  /** 拖拽页面controller封装 */
  private pageDrag: PageDragAction | null = null;
  /** 长按预截图Promise */
  private snapshotPromise?: Promise<boolean>
  private snapshotTimestamp: number = 0;
  private gridMargin: number = 0;
  private foldPaddingSide: number = 0;
  /**
   * 参与动效的页面 swiperKey
   */
  private animatedPage: string[] = [];

  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();

  public static getInstance(): PageEditViewModel {
    if (!(PageEditViewModel.instance instanceof PageEditViewModel)) {
      PageEditViewModel.instance = new PageEditViewModel();
    }
    return PageEditViewModel.instance;
  }

  /**
   * 设置swiperPage中的gridMargin
   *
   * @param gridMargin
   */
  public setGridMargin(gridMargin: number): void {
    this.gridMargin = gridMargin;
  }

  /**
   * 设置swiperPage中的foldPaddingSide
   *
   * @param foldPaddingSide
   */
  public setFoldPaddingSide(foldPaddingSide: number): void {
    this.foldPaddingSide = foldPaddingSide;
  }

  /**
   * 获取整页拖拽截图的间距,三屏额外处理宫格偏移
   */
  public getRowSpace(): number {
    if (DisplayCountViewModel.getInstance().getDisplayCount() === 3) {
      return (this.gridMargin * 2 - this.foldPaddingSide) * EditModeUtils.getDesktopScale();
    } else {
      return this.gridMargin * 2 * EditModeUtils.getDesktopScale();
    }
  }

  /**
   * 获取编辑模式背景板位移
   */
  public getScreenXTranslate(): number {
    return AppStorage.get('screenWidth') as number - 2 * EditModeUtils.getPrevNextMargin();
  }

  /**
   * 新增空白页当前页动效
   *
   * @param isOuter 是否是小外屏
   */
  public addBlankPageCurrentPageAnimate(isOuter: boolean = false) {
    log.showInfo(`addBlankPageCurrentPageAnimate`);
    pageEditManager.editModeBlankAnimatePageData.blankAnimatePageOpacity = 0;
    pageEditManager.editModeBlankAnimatePageData.blankAnimatePageScale = 0.5;
    animateTo({
      duration: EditModeConstants.PAGE_EDIT_ANIMATE_TIME - EditModeConstants.PAGE_EDIT_ANIMATE_DELAY_TIME,
      delay: EditModeConstants.PAGE_EDIT_ANIMATE_DELAY_TIME,
      curve: EditModeConstants.PAGE_SQUEEZE_CURVE,
      onFinish: () => {
        PageDragManager.getInstance().onCancelSqueezeEvent(false);
        pageEditManager.handleAddPage(isOuter);
        pageEditManager.editModeEditPageData.handleEditPageState = EditModePageActionEnum.WAITTING_ACTION;
      }
    }, () => {
      pageEditManager.editModeBlankAnimatePageData.blankAnimatePageOpacity = 1;
      pageEditManager.editModeBlankAnimatePageData.blankAnimatePageScale = 1;
    });
  }

  /**
   * 删除空白页当前页动效
   *
   * @param isOuter 是否是外屏
   */
  public deleteBlankPageCurrentPageAnimate(isOuter: boolean) {
    log.showInfo(`deleteBlankPageCurrentPageAnimate start`);
    pageEditManager.editModeBlankAnimatePageData.blankAnimatePageOpacity = 1;
    pageEditManager.editModeBlankAnimatePageData.blankAnimatePageScale = 1;
    animateTo({
      duration: EditModeConstants.PAGE_EDIT_DELETE_ANIMATE_TIME,
      curve: EditModeConstants.PAGE_SQUEEZE_CURVE,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        log.showInfo(`deleteBlankPageCurrentPageAnimate finish`);
        PageDragManager.getInstance().onCancelSqueezeEvent(false);
        pageEditManager.handleDeletePage(PageDragManager.getInstance().getDraggingPage()[0], isOuter)
          .then(() => {
          log.showInfo(`handleDeletePage finish`);
          PageDragManager.getInstance().onDragEndEvent();
          pageEditManager.editModeEditPageData.handleEditPageState = EditModePageActionEnum.WAITTING_ACTION;
        });
      }
    }, () => {
      pageEditManager.editModeBlankAnimatePageData.blankAnimatePageOpacity = 0;
      pageEditManager.editModeBlankAnimatePageData.blankAnimatePageScale = 0.5;
    });
  }

  /**
   * 当前是否未在加删页
   */
  public isNotEditingPage(): boolean {
    return pageEditManager.editModeEditPageData.handleEditPageState === EditModePageActionEnum.WAITTING_ACTION;
  }

  /**
   * 当前是否在删除页面
   */
  public isDeletePage(): boolean {
    return pageEditManager.editModeEditPageData.handleEditPageState === EditModePageActionEnum.DELETEING_BLANK_PAGE;
  }

  /**
   * 当前是否处于拖拽状态
   */
  public isDragingPage(): boolean {
    return pageEditManager.dragPageData.dragPageState === EditModePageActionEnum.START_DRAG_PAGE ||
      pageEditManager.dragPageData.dragPageState === EditModePageActionEnum.DRAG_PAGE_MOVING;
  }

  /**
   * 当前是否正在加最后一页
   */
  public isAddingLastPage(isOuterDesktop: boolean): boolean {
    const pages: number[] = SwiperLoadData.getInstance().getPages().slice(0);
    log.showInfo(`EditModeAddPage ${pages.length} ${pageEditManager.editModeEditPageData.handleEditPageState}`);
    const displayCount: number = DisplayCountViewModel.getInstance().getDisplayCount();
    return pages.length === LaunchLayoutCacheManager.getInstance().selectMaxPageCount() - displayCount &&
      pageEditManager.editModeEditPageData.handleEditPageState === EditModePageActionEnum.ADDING_BLANK_PAGE;
  }

  /**
   * 当前是否正在删除最后一页
   */
  public isDeletingLastPage(isOuterDesktop: boolean): boolean {
    const pages: number[] = SwiperLoadData.getInstance().getPages().slice(0);
    log.showInfo(`EditModeAddPage ${pages.length} ${pageEditManager.editModeEditPageData.handleEditPageState}`);
    return pages.length === LaunchLayoutCacheManager.getInstance().selectMaxPageCount() &&
      pageEditManager.editModeEditPageData.handleEditPageState === EditModePageActionEnum.DELETEING_BLANK_PAGE;
  }

  /**
   * 结束拖拽页面，更新状态，释放拖拽图
   */
  public endDragPage(): void {
    log.showInfo(`viewModel endDragPage`);
    pageEditManager.dragPageData.dragPageState = EditModePageActionEnum.WAITTING_ACTION;
    try {
      dragSnapshotHelper.releaseSnapshot(
        SnapshotType.BOTH, `GridSwiper_SingePage_${pageEditManager.dragPageData.startDragPageSwiperKey}`);
    } catch {
      log.showError(`viewModel endDragPage releaseSnapshot error`);
    }
  }

  /**
   * 创建页面拖拽事件，自定义onDragStart等方法，并触发拖拽
   *
   * @param selectPage 选中页面
   * @param touchPoint 手指按压点
   * @param isOuter 是否是小外屏
   */
  public createDragAction(
    selectPage: DragingPageType,
    touchPoint: Position,
    isOuter: boolean,
    uiContext?: UIContext
  ): void {
    log.showWarn(`createDragAction isOuter:${isOuter} pageIndex:${selectPage.pageIndex} swiperKey:${selectPage.pageKey}`)
    PageDragManager.getInstance().initDragInfo(selectPage.pageIndex);
    Trace.start(EditModeConstants.PAGE_DRAG_TRACE_CREATE_DRAG);
    this.pageDrag = new PageDragAction({
      dragItemImage: selectPage.image,
      imageRadius: selectPage.radius,
      touchPoint: touchPoint,
      onDragStart: (): void => {
        Trace.end(EditModeConstants.PAGE_DRAG_TRACE_CREATE_DRAG);
        Trace.start(Trace.CORE_METHOD_PAGE_DRAG);
        EditModeAccessibilityUtil.textAnnouncedForDragPage();
        // 隔离折叠屏、外屏、加号页
        log.showWarn(`dragController dragStart pageIndex:${selectPage.pageIndex} swiperKey:${selectPage.pageKey}`);
        pageEditManager.dragPageData.startDragPageSwiperKey = selectPage.pageKey;
        AppStorage.setOrCreate('isDrag', true);
        this.desktopContext?.eventHub.emit(EventConstants.PRE_DRAG_PAGE_IN_EDIT_MODE, selectPage.pageKey);
        PageDragManager.getInstance().onDragStartEvent();
        setTimeout(() => {
          this.recoverPageScale();
        })
      },
      onDragEnd: (): void => {
        // 隔离折叠屏、外屏、加号页
        AppStorage.setOrCreate('isDrag', false);
        log.showInfo(`singlePage onDragEnd`);
      },
      onDragFinish: (): void => {
        Trace.end(Trace.CORE_METHOD_PAGE_DRAG);
        log.showInfo(`singlePage onDragFinish`);
      },
      onDragCancel: (): void => {
        Trace.end(EditModeConstants.PAGE_DRAG_TRACE_CREATE_DRAG);
        Trace.end(Trace.CORE_METHOD_PAGE_DRAG);
        log.showInfo(`singlePage onDragCancel`);
        PageDragManager.getInstance().onDragEndEvent();
        this.desktopContext?.eventHub.emit(EventConstants.END_DRAG_PAGE_IN_EDIT_MODE);
      }
    });
    this.pageDrag?.executeDrag(uiContext);
  }

  /**
   * 获取swiper上组件id，用于截图提供给页面拖拽组件
   *
   * @param isOuterDesktop 是否为外屏
   * @param index
   */
  public getSwiperComponentId(isOuterDesktop: boolean, index: number) {
    return isOuterDesktop ? (CommonConstants.SWIPER_GRID_WORKSPACE_TAG + index + '_OuterDesktop') :
      (CommonConstants.SWIPER_GRID_WORKSPACE_TAG + index);
  }

  /**
   * 获取编辑模式背景板宽高
   *
   * @param isOuterDesktop 是否为外屏
   * @param index
   */
  public getScreenWidthOrHeight(isScreenWidth: boolean, isOuter?: boolean): number {
    if (isOuter) {
      return EditModeUtils.convertWithDesktopScale(EditModeUtils.getOuterBackgroundSize());
    }
    if (isScreenWidth) {
      return EditModeUtils.convertWithDesktopScale(EditModePageStaticData.editModeBgWidth);
    } else {
      return EditModeUtils.convertWithDesktopScale(EditModePageStaticData.editModeBgHeight);
    }
  }

  /**
   * 获取编辑模式swiper组件高度
   */
  public getSwiperHeight(): number {
    let workSpaceHeight = AppStorage.get('workSpaceHeight') as number;
    let swiperHeight = workSpaceHeight - LayoutViewModel.getInstance().getSysUITopHeight();
    if (!DeviceHelper.isPhone()) {
      let screenHeight = AppStorage.get<number>('screenHeight') as number;
      swiperHeight = swiperHeight * (screenHeight - StyleConstants.SMART_DOCK_MARGIN_TOP) / screenHeight;
    }
    return swiperHeight;
  }

  /**
   * 获取编辑模式空白页删除按钮距离背板顶部的偏移值
   *
   * @param isOuter 是否是外屏
   * @returns 编辑模式空白页删除按钮距离背板顶部的偏移值
   */
  public getDeleteButtonYFromBgTop(isOuter: boolean): number {
    if (isOuter) {
      // 编辑模式背板高度
      const bgHeight = EditModeUtils.convertWithDesktopScale(EditModeUtils.getOuterBackgroundSize());
      // 编辑模式删除空白页按钮距离编模式背板顶部距离
      const buttonPosition = bgHeight -
      EditModeConstants.OUTER_PAGE_EDIT_BUTTON_SIZE - this.editModeStyleConfig.pageEditDeleteIconMarginBottom;
      return buttonPosition;
    } else {
      // 编辑模式背板高度
      const bgHeight = EditModeUtils.convertWithDesktopScale(EditModePageStaticData.editModeBgHeight);
      // 编辑模式删除空白页按钮距离编模式背板顶部距离
      const buttonPosition = bgHeight -
      this.editModeStyleConfig.pageEditButtonSize - this.editModeStyleConfig.pageEditDeleteIconMarginBottom;
      return buttonPosition;
    }
  }

  /**
   * 获取编辑模式截图设置主屏按钮距离背板顶部的偏移值
   *
   * @param gridHeight 宫格高度
   * @returns 距离
   */
  public getHomepageBtnYFromBgTop(): number {
    return EditModeUtils.convertWithDesktopScale(this.getOneThirdSpace());
  }

  /**
   * 获取编辑模式宫格外背景板内三分之一高度
   *
   * @returns 三分之一高度
   */
  public getOneThirdSpace(): number {
    let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    let screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    let workSpaceHeight: number = AppStorage.get<number>('workSpaceHeight') as number;
    let itemPadding: number = AppStorage.get<number>('itemPadding') as number;
    // 背景板高度
    let bgHeight: number = EditModeUtils.getBackgroundHeight(screenHeight, screenWidth, workSpaceHeight);
    // 宫格高度
    let gridHeight: number = LayoutViewModel.getInstance().calculateDesktop().mGridHeight ?? 0;
    // 按钮高度
    let btnSize: number =
      EditModeConstants.HOME_PAGE_BUTTON_SIZE / this.editModeStyleConfig.swiperEditScaleRate;
    log.showInfo(`getOneThirdSpace>>> bgHeight:${bgHeight}, itemPadding:${itemPadding}, gridHeight:${gridHeight}, btnSize:${btnSize}`);
    return (bgHeight + itemPadding - gridHeight - btnSize) / 3;
  }

  /**
   * 获取编辑模式背景板中心相对swiper中心的偏移
   *
   * @returns 中心偏移
   */
  public getEditModeBgTranslateY(): number {
    let desktopMarginTop: number = LayoutViewModel.getInstance().calculateDesktop().mDesktopMarginTop as number;
    let statusHeight = LayoutViewModel.getInstance().getSysUITopHeight();
    let marginTop: number = desktopMarginTop - statusHeight;
    let swiperHeight = this.getSwiperHeight();
    let gridHeight: number = LayoutViewModel.getInstance().calculateDesktop().mGridHeight as number;
    let bottom: number = swiperHeight - gridHeight - marginTop;
    // 背板y轴位移高度，使grid相对背板居中
    return (marginTop - bottom) / 2;
  }

  /**
   * 获取宫格区相对swiper顶的偏移
   *
   * @param editModeBgTranslateY 背景板中心相对stack中心偏移量
   * @param offsetY 宫格区offset
   * @returns 偏移
   */
  public getGridMarginTopFromSwiper(editModeBgTranslateY: number, offsetY: number): number {
    let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    let screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    let workSpaceHeight: number = AppStorage.get<number>('workSpaceHeight') as number;
    // 背景板高度
    let bgHeight: number = EditModeUtils.getBackgroundHeight(screenHeight, screenWidth, workSpaceHeight);
    // swiper高度
    let swiperHeight = this.getSwiperHeight();
    // 宫格高度
    let gridHeight: number = LayoutViewModel.getInstance().calculateDesktop().mGridHeight ?? 0;
    let result: number = swiperHeight / 2 + editModeBgTranslateY + bgHeight / 2 - gridHeight - offsetY -
    PageEditViewModel.getInstance().getOneThirdSpace();
    log.showInfo(`getGridMarginTopFromSwiper end, result: ${result}`);
    return result < 0 ? 0 : result;
  }

  /**
   * 获取**非编辑模式**宫格区相对swiper顶的偏移
   *
   * @returns 偏移
   */
  public getNEGridMarginTopFromSwiper(): number {
    let desktopMarginTop: number = LayoutViewModel.getInstance().calculateDesktop().mDesktopMarginTop as number;
    let sysUITopHeight: number = LayoutViewModel.getInstance().getSysUITopHeight();
    log.showInfo(`getNEGridMarginTopFromSwiper>>>${desktopMarginTop} - ${sysUITopHeight}`);
    return desktopMarginTop - sysUITopHeight;
  }

  /**
   * 获取增加设置主屏按钮后落位白框相对原位置y轴偏移
   *
   * @returns y轴偏移
   */
  public getWhiteBoxTranslateY(): number {
    if (editModeManager.isInEditMode() && PageInfoManager.getInstance().isHomePageSetSupport()) {
      // // 背景板中心相对swiper中心的偏移
      let editModeBgTranslateY: number = this.getEditModeBgTranslateY();
      // 编辑模式下宫格区距离swiper顶的偏移
      let gridMarginTopFromSwiper: number = this.getGridMarginTopFromSwiper(editModeBgTranslateY,0);
      // 非编辑模式下宫格区距离swiper顶的偏移
      let neGridMarginTop: number = this.getNEGridMarginTopFromSwiper();
      // 费编辑模式下落位白框偏移为0，编辑模式下加偏移
      let whiteBoxTranslateY: number = gridMarginTopFromSwiper - neGridMarginTop;
      log.showInfo(`getWhiteBoxTranslateY: ${gridMarginTopFromSwiper} - ${neGridMarginTop} = ${whiteBoxTranslateY}`);
      return whiteBoxTranslateY;
    }
    log.showInfo(`getWhiteBoxTranslateY: 0`);
    return 0;
  }

  /**
   * 获取拖拽截图圆角
   */
  public getSnapshotRadius(isOuter?: boolean): number {
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    return EditModeUtils.convertWithDesktopScale(EditModeUtils.getBgBorderRadius(screenWidth, isOuter));
  }

  /**
   * 更新并记录编辑模式背景板宽高，用于拖拽页面
   */
  public updateEditModeBackGroundWidthAndHeight() {
    EditModePageStaticData.editModeBgWidth = AppStorage.get<number>('screenWidth') as number -
      2 * EditModeUtils.getPrevNextMargin();
    // screenWidth * EditModeUtils.getSwiperScale() -
      EditModeUtils.getPrevNextMargin() * EditModeUtils.getDesktopScale() * 2
    EditModePageStaticData.editModeBgHeight = EditModeUtils.getBackgroundHeight(
      AppStorage.get<number>('screenWidth') as number,
      AppStorage.get<number>('screenHeight') as number,
      AppStorage.get<number>('workSpaceHeight') as number
    );
  }

  /**
   * 更新并记录编辑模式背景板距离桌面左上角的高度及背景板中心点y轴位置，用于拖拽页面
   *
   * @param editModeBgTranslateY 背景板与同级swiper之间的y轴偏移值
   * @param gridSwiperScale gridSwiper层缩放比例
   * @param singePageSwiperScale singePage层缩放比例
   */
  public updateEditModeBackGroundPointY(
    editModeBgTranslateY: number,
    gridSwiperScale: number,
    singePageSwiperScale: number,
    isOuter: boolean
  ): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(isOuter)) {
      return;
    }
    // 工作区高度
    let workSpaceHeight = AppStorage.get<number>('workSpaceHeight') as number;
    // 上方消息栏高度
    let statusHeight = LayoutViewModel.getInstance().getSysUITopHeight();
    // 桌面状态下swiper高度
    let swiperHeight = workSpaceHeight - statusHeight;
    if (!DeviceHelper.isPhone()) {
      let screenHeight = AppStorage.get<number>('screenHeight') as number;
      swiperHeight = swiperHeight * (screenHeight - StyleConstants.SMART_DOCK_MARGIN_TOP) / screenHeight;
    }
    // 桌面状态下swiper中心点相对于swiper组件左上角的Y坐标
    let originSwiperHeight = swiperHeight / 2;
    // 桌面状态下第一次缩放中心点相对于swiper组件左上角的Y坐标
    let normalCenterY = EditModeUtils.getScaleCenterY();
    // 第一次缩放后的swiper中心点相对于桌面左上角的Y坐标
    let firstScalePosition = (originSwiperHeight - normalCenterY) * gridSwiperScale + normalCenterY + statusHeight;
    // 第二次缩放后的swiper中心点相对于桌面左上角的Y坐标
    let secondScalePosition = firstScalePosition;
    // 第二次缩放后的编辑模式背景板中心点相对于桌面左上角的Y坐标
    EditModePageStaticData.editModeBgCenterPointY = secondScalePosition +
      editModeBgTranslateY * singePageSwiperScale * gridSwiperScale;
    OpenFolderStyleConfig.getInstance().setEditModeBgCenterPointY(EditModePageStaticData.editModeBgCenterPointY);
    // 第二次缩放后的编辑模式背景板左上角相对于桌面左上角的Y坐标
    if (isOuter) {
      pageEditManager.editModeDragAnimatePageData.editModeBgTopPointY =
        EditModeConstants.OUTER_EDIT_MODE_BG_TOP_POINT_Y;
    } else {
      pageEditManager.editModeDragAnimatePageData.editModeBgTopPointY = secondScalePosition +
        editModeBgTranslateY * singePageSwiperScale * gridSwiperScale -
        (EditModeUtils.convertWithDesktopScale(EditModePageStaticData.editModeBgHeight)) / 2;
    }
    log.showInfo(`updateEditModeBackGroundPointY vp2px ${vp2px(1)},
      workSpaceHeight ${workSpaceHeight},
      statusHeight ${statusHeight},
      originSwiperHeight ${originSwiperHeight},
      normalCenterY ${normalCenterY},
      gridSwiperScale ${gridSwiperScale},
      firstScalePosition ${firstScalePosition},
      secondScalePosition ${secondScalePosition},
      EditModeBgTranslateY ${editModeBgTranslateY},
      centerPointY ${EditModePageStaticData.editModeBgCenterPointY},
      TopPointY ${pageEditManager.editModeDragAnimatePageData.editModeBgTopPointY}
    `);
  }

  /**
   * 获取编辑模式加减页动效组件背景板底部与swiper底部之间的距离，用于定位删除按钮
   *
   * @param editModeBgTranslateY 背景板与同级swiper之间的y轴偏移值
   * @param gridSwiperScale gridSwiper层缩放比例
   * @param singePageSwiperScale singePage层缩放比例
   */
  public getEditModeBackGroundBottomDistanceY(editModeBgTranslateY: number, gridSwiperScale: number): number {
    // 工作区高度
    let workSpaceHeight = AppStorage.get<number>('workSpaceHeight') as number;
    // 上方消息栏高度
    let statusHeight = LayoutViewModel.getInstance().getSysUITopHeight();
    // 桌面状态下swiper高度
    let swiperHeight = workSpaceHeight - statusHeight;
    if (!DeviceHelper.isPhone()) {
      let screenHeight = AppStorage.get<number>('screenHeight') as number;
      swiperHeight = swiperHeight * (screenHeight - StyleConstants.SMART_DOCK_MARGIN_TOP) / screenHeight;
    }
    // 编辑模式状态下动效组件高度
    let editSwiperHeight = swiperHeight * gridSwiperScale;
    // 编辑模式下背板高度
    let editBgHeight = EditModeUtils.convertWithDesktopScale(EditModePageStaticData.editModeBgHeight);
    // 无偏移下编辑模式动效组件与背板底部差距值
    let originDistanceY = (editBgHeight - editSwiperHeight) / 2;
    log.showInfo(`getEditModeBackGroundBottomDistanceY vp2px ${vp2px(1)},
      originDistanceY ${originDistanceY},
      editModeBgTranslateY ${editModeBgTranslateY},
      editSwiperHeight ${editSwiperHeight},
      editBgHeight ${editBgHeight}
    `);
    return originDistanceY + EditModeUtils.convertWithDesktopScale(editModeBgTranslateY);
  }

  /**
   * 拖拽页面落位事件
   *
   * @param event 落位事件
   * @param isOuter 是否是外屏
   */
  public dropPageAnimate(event: DragEvent, isOuter: boolean) {
    event.useCustomDropAnimation = true;
    // 拖拽起始页
    const oldPageKey: number = pageEditManager.dragPageData.startDragPageSwiperKey;
    log.showInfo(`onDrop oldPageIndex: ${oldPageKey}`);
    let rectangle: Rectangle = event.getPreviewRect();
    // 松手时拖拽预览图中心点位置
    let dropX: number = Number(rectangle.x) + Number(rectangle.width) / 2;
    let dropY: number = Number(rectangle.y) + Number(rectangle.height) / 2;
    // 编辑模式下背景板中心点位置
    let targetX: number = AppStorage.get<number>('screenWidth') as number / 2;
    let targetY: number = EditModePageStaticData.editModeBgCenterPointY;
    if (isOuter) {
      targetY = EditModeConstants.OUTER_EDIT_MODE_BG_TARGET_Y;
    }
    log.showInfo(`dropPageAnimate targetX: ${targetX}, targetY: ${targetY}`);
    let param = new DropAnimationParam(`GridSwiper_singePage_${oldPageKey}`, dropX, dropY, targetX, targetY);
    // 落位动效尺寸设置
    let bgHeight: number = 0;
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let screenHeight = AppStorage.get<number>('screenHeight') as number;
    let workSpaceHeight = AppStorage.get<number>('workSpaceHeight') as number;
    if (isOuter) {
      bgHeight = EditModeUtils.getOuterBackgroundSize(screenWidth);
      param.startWidth = Number(rectangle.width) ||
      EditModeUtils.convertWithDesktopScale(bgHeight);
    } else {
      bgHeight = EditModeUtils.getBackgroundHeight(screenHeight, screenWidth, workSpaceHeight)
      param.startWidth = Number(rectangle.width) ||
      EditModeUtils.convertWithDesktopScale(screenWidth);
    }
    param.startWidth = Number(rectangle.width) ||
    EditModeUtils.convertWithDesktopScale(screenWidth);
    param.startHeight = Number(rectangle.height) ||
    EditModeUtils.convertWithDesktopScale(bgHeight);
    param.endWidth = this.getScreenWidthOrHeight(true, isOuter);
    param.endHeight = this.getScreenWidthOrHeight(false, isOuter);
    param.curve = curves.springMotion(0.53, 0.85);
    // 执行落位动效
    event.executeDropAnimation(() => {
      dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, param);
    });
  }

  /**
   * 编辑模式上方文本框拖拽页面提示语显隐动效
   *
   * @param tipTextOpacity 提示语透明度
   * @param callback 动效回调
   */
  public dragPageTipShowOrHideAnimate(tipTextOpacity: number, callback?: Function): void {
    animateTo({
      duration: 200,
      curve: Curve.Sharp,
      onFinish: () => {
        callback?.();
      }
    }, () => {
      pageEditManager.editModeDragPageTipTextData.dragPageTipTextOpacity = tipTextOpacity;
    });
  }

  /**
   * 长按事件 => 截图
   * @param builder 截图build
   * @param event 手势事件
   * @param index 页面顺序
   * @param pageKey 页面key
   */
  public onLongPressForSnapshot(builder: CustomBuilder, event: GestureEvent, index: number
    , pageKey: number, isOuter: boolean): void {
    this.snapshotPromise = this.createSnapshot(builder, index, pageKey, isOuter);
    this.snapshotTimestamp = event.timestamp;
  }

  /**
   * 长按事件松手 => 截图
   * @param event
   * @param pageKey
   * @returns
   */
  public onLongPressForSnapshotEnd(event: GestureEvent, pageKey: number): boolean {
    // 如果触发了第二次截图就不release了
    if (this.snapshotTimestamp !== event.timestamp) {
      return false;
    }
    this.snapshotPromise?.then(() => {
      if (pageEditManager.dragPageData.dragPageState >= EditModePageActionEnum.START_DRAG_PAGE) {
        return;
      }
      log.showInfo('release snapshot on longPressForSnapshot.actionEnd');
      const swiperId = this.getSinglePageIdByPageKey(pageKey);
      dragSnapshotHelper.releaseSnapshot(SnapshotType.BOTH, swiperId);
    })
    return true;
  }

  /**
   * 触发动效的长按手势
   * @param pageIndex
   * @param uiCtx
   * @param isOuter
   */
  public onLongPressForAnimate(pageIndex: number, uiCtx: UIContext, isOuter: boolean): void {
    this.animatedPage = PageDragManager.getInstance()
      .getRelativePages(pageIndex)
      .map((pageIndex: number): string => PageDragManager.getInstance().getPageUniqueKey(pageIndex));
    this.doPageLongPressAnimate(uiCtx)
  }

  /**
   * 触发动效的长按手势结束
   */
  public onLongPressForAnimateEnd():void {
    log.showInfo('recover scale on longPressForAnimate.actionEnd');
    this.recoverPageScale(true);
  }

  /**
   * 触发起拖的长按手势
   * @param event
   * @param index
   * @param swiperKey
   * @param isOuter
   * @returns
   */
  public async onLongPressForDrag(event: GestureEvent, index: number, swiperKey: number,
    isOuter: boolean, uiContext?: UIContext): Promise<void> {
    log.showWarn(`waitting snapshot, swiperKey:${swiperKey} index:${index}`);
    if (!this.snapshotPromise) {
      log.showWarn('miss pageDrag snapshot, skip page drag');
      return;
    }
    pageEditManager.dragPageData.dragPageState = EditModePageActionEnum.START_DRAG_PAGE;
    this.snapshotPromise.then((snapshotSuccess: boolean) => {
      if (!snapshotSuccess) {
        log.showWarn('page snapshot failed, skip page drag');
        return;
      }
      log.showWarn(`snapshot finished, start page drag. index:${index} swiperKey:${swiperKey}`);
      const singlePageId = this.getSinglePageIdByPageKey(swiperKey);
      const snapshot = dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, singlePageId) as image.PixelMap;
      let bgWidth = this.getScreenWidthOrHeight(true, isOuter);
      let bgHeight = this.getScreenWidthOrHeight(false, isOuter);
      const dragPage = new DragingPageType();
      dragPage.width = bgWidth;
      dragPage.height = bgHeight;
      dragPage.defaultX = event.fingerList[0].localX;
      dragPage.defaultY = event.fingerList[0].localY;
      dragPage.image = snapshot;
      dragPage.pageIndex = index;
      dragPage.pageKey = swiperKey;
      this.createDragAction(dragPage, this.getTouchPoint(event, index, bgWidth, bgHeight), isOuter, uiContext);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, singlePageId)
      ?.setWidth(bgWidth)
        .setHeight(bgHeight)
        .setDropSnapshot(snapshot)
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
    }).catch((err: Error) => {
      log.showError(`onLongPressForDrag error: ${err}`);
    })
  }

  /**
   * 长按页面时的缩放动效
   * @returns
   */
  private async doPageLongPressAnimate(uiCtx: UIContext): Promise<void> {
    Promise.all(this.animatedPage.map((swiperKey: string) => {
      const viewData = this.singlePageItemObserver.get(swiperKey);
      return viewData && this.pageScaleAnimate(viewData, uiCtx);
    }))
  }

  /**
   * 复原singlepage的scale
   *
   * @param needAnimate 是否需要动画
   */
  public async recoverPageScale(needAnimate: boolean = false): Promise<void> {
    log.showInfo('recoverPageScale');
    const viewDataList = this.animatedPage.map(swiperKey => this.singlePageItemObserver.get(swiperKey));
    this.animatedPage.length = 0;
    if (needAnimate) {
      await new Promise<void>((resolve) => {
        animateTo({
          duration: EditModeConstants.PAGE_SCALE_DURATION,
          curve: EditModeConstants.PAGE_SCALE_CURVE,
          onFinish: resolve
        }, () => {
          viewDataList.forEach(viewData => viewData && (viewData.pageScale = 1))
        })
      })
    } else {
      viewDataList.forEach(viewData => viewData && (viewData.pageScale = 1))
    }
  }

  private async pageScaleAnimate(pageItemViewData: PageEditItemViewData, uiCtx: UIContext): Promise<void> {
    log.showInfo(`pageScaleAnimate ${EditModeConstants.PAGE_ZOOM_IN_SCALE}`);
    await new Promise<void>((resolve) => {
      uiCtx.keyframeAnimateTo({ onFinish: resolve }, [
        {
          duration: EditModeConstants.PAGE_SCALE_DURATION,
          curve: EditModeConstants.PAGE_SCALE_CURVE,
          event: () => {
            pageItemViewData.pageScale = EditModeConstants.PAGE_ZOOM_OUT_SCALE
          }
        },
        {
          duration: EditModeConstants.PAGE_SCALE_DURATION,
          curve: EditModeConstants.PAGE_SCALE_CURVE,
          event: () => {
            pageItemViewData.pageScale = EditModeConstants.PAGE_ZOOM_IN_SCALE
          }
        }
      ])
    })
  }

  /**
   * 获取加删页时用于避免页面动效重叠的时延
   * @returns DelayTime 时延
   */
  public getPageEditAnimateDelayTime(): number {
    return this.isDeletePage() ? EditModeConstants.PAGE_EDIT_ANIMATE_DELAY_TIME : 0;
  }

  /**
   * 触发加删页时附近页面的位移动效
   * @param pageIndex
   * @param uiCtx
   * @param isOuter
   */
  public onAddingOrDeletingPageForAnimate(translateX: number, pageIndex: number, uiCtx: UIContext,
    isOuter: boolean): void {
    const animatedPage = PageDragManager.getInstance().getPageUniqueKey(pageIndex);
    const viewData = this.singlePageItemObserver.get(animatedPage);
    if (viewData) {
      this.pageTranslateXAnimate(translateX, viewData, uiCtx);
    }
  }

  /**
   * 清空页面的位移动效
   *
   * @param isOuter
   * @returns
   */
  public recoverPageTranslateX(pageIndex: number, isOuter: boolean): void {
    const animatedPage = PageDragManager.getInstance().getPageUniqueKey(pageIndex);
    const viewData = this.singlePageItemObserver.get(animatedPage);
    if (viewData) {
      viewData.translateX = 0;
    }
  }

  private pageTranslateXAnimate(
    translateX: number,
    pageItemViewData: PageEditItemViewData,
    uiCtx: UIContext
  ): void {
    uiCtx.animateTo({
      duration: EditModeConstants.PAGE_SCALE_DURATION,
      delay: this.getPageEditAnimateDelayTime(),
      curve: EditModeConstants.PAGE_SQUEEZE_CURVE,
      onFinish: () => {
        if (pageEditManager.dragPageData.dragPageState === EditModePageActionEnum.DRAG_PAGE_MOVING) {
          log.showInfo(`clear translateAnimate`);
          // 动效执行完后将handleDragPageState重置，放开阻拦
          pageEditManager.dragPageData.dragPageState = EditModePageActionEnum.START_DRAG_PAGE;
        }
      }
    }, () => {
      if (RTLUtil.isRTL()) {
        pageItemViewData.translateX = -translateX;
      } else {
        pageItemViewData.translateX = translateX;
      }
    })
  }

  private getSinglePageIdByPageKey(pageKey: number): string {
    return `GridSwiper_singePage_${pageKey}`;
  }

  private async createSnapshot(
    builder: CustomBuilder,
    index: number,
    pageKey: number,
    isOuter: boolean
  ): Promise<boolean> {
    try {
      log.showWarn(`create pageDrag snapshot. pageIndex:${index} pageKey:${pageKey}`)
      Trace.start(EditModeConstants.PAGE_DRAG_TRACE_SNAPSHOT_GRID);
      const singlePageId = this.getSinglePageIdByPageKey(pageKey);
      const showingPageIds: number[] = PageDragManager.getInstance().getRelativePages(index);
      await Promise.all(showingPageIds.map(async (pageId: number, i: number) => {
        const gridId = this.getSwiperComponentId(isOuter, pageId);
        const gridSnapshot: image.PixelMap = await componentSnapshot.get(gridId);
        pageEditManager.editModeDragAnimatePageData.dragSnapshot.push(gridSnapshot);
        if (i === 0) {
          const gridSnapshotInfo = await gridSnapshot.getImageInfo();
          pageEditManager.editModeDragAnimatePageData.imageSizeWidth = gridSnapshotInfo.size.width;
          pageEditManager.editModeDragAnimatePageData.imageSizeHeight = gridSnapshotInfo.size.height;
          log.showInfo(`gridImageSize width:${gridSnapshotInfo.size.width} height:${gridSnapshotInfo.size.width}`);
        }
      }));
      Trace.end(EditModeConstants.PAGE_DRAG_TRACE_SNAPSHOT_GRID);

      Trace.start(EditModeConstants.PAGE_DRAG_TRACE_SNAPSHOT_BUILDER);
      const pageSnapshot = await dragSnapshotHelper.snapshotFromBuilderAsync(builder, SnapshotType.BOTH, singlePageId);
      Trace.end(EditModeConstants.PAGE_DRAG_TRACE_SNAPSHOT_BUILDER);
      // 释放swiper组件截图
      pageEditManager.editModeDragAnimatePageData.dragSnapshot.forEach(value => value.release());
      pageEditManager.editModeDragAnimatePageData.dragSnapshot = [];
      if (!pageSnapshot) {
        log.showWarn(`create pageDrag snapshot from build failed`);
        return false;
      }
      return true;
    } catch (error) {
      log.showError(`create pageDrag snapshot failed, error:${error.message}`);
      pageEditManager.editModeDragAnimatePageData.dragSnapshot.forEach((value) => value.release());
      pageEditManager.editModeDragAnimatePageData.dragSnapshot = [];
      Trace.end(EditModeConstants.PAGE_DRAG_TRACE_SNAPSHOT_GRID);
      Trace.end(EditModeConstants.PAGE_DRAG_TRACE_SNAPSHOT_BUILDER);
    }
    return false;
  }

  /**
   * 获取跟手点位置
   * @param event
   * @param pageIndex
   * @returns
   */
  private getTouchPoint(event: GestureEvent, pageIndex: number, bgHeight: number, bgWidth: number): Position {
    const displayCnt: number = DisplayCountViewModel.getInstance().getDisplayCount();
    const zoomInScaleOffsetX = (EditModeConstants.PAGE_ZOOM_IN_SCALE - 1) * bgHeight / 2;
    const zoomInScaleOffsetY = (EditModeConstants.PAGE_ZOOM_IN_SCALE - 1) * bgWidth / 2;
    const screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    let screenOffset = 0;
    let rtlScreenOffset = 0;
    // 三屏中间屏背板占全屏，不需要偏移
    if (displayCnt !== 3 || pageIndex % 3 !== 1) {
      screenOffset = (screenWidth / displayCnt) * (pageIndex % displayCnt);
      rtlScreenOffset = (screenWidth / displayCnt) * (displayCnt - 1 - pageIndex % displayCnt);
    }
    log.showInfo(`getTouchPoint ${event.fingerList[0].localX}_${screenWidth}_${zoomInScaleOffsetX}`);
    return {
      x: EditModeUtils.convertWithDesktopScale(event.fingerList[0].localX +
        (RTLUtil.isRTL() ? rtlScreenOffset : screenOffset)) + zoomInScaleOffsetX,
      y: EditModeUtils.convertWithDesktopScale(event.fingerList[0].localY) + zoomInScaleOffsetY
    };
  }

  /**
   * 判断当前页是否是空白页，用于显示删除按钮
   *
   * @param pageKey: 要判断的页面
   * @returns 当前页是否是空白页
   */
  public isCurrentPageBlank(pageKey: number, isOuter?: boolean): boolean {
    if (pageEditManager.pageEditState.isFoldExpandStatus) {
      const pages = SwiperLoadData.getInstance().getPages();
      const displayCnt: number = DisplayCountViewModel.getInstance().getDisplayCount();
      let neighborPage = EditModeUtils.getCurrentShowingPage(pages.indexOf(pageKey), displayCnt);
      let currentPageBlank = true;
      for (let i = 0; i < neighborPage.length; i++) {
        if (!pageEditManager.getRealBlankPageList(isOuter).has(pages[neighborPage[i]])) {
          return false;
        }
      }
      return true;
    }
    return pageEditManager.getRealBlankPageList(isOuter).has(pageKey);
  }

  public readonly singlePageItemObserver: WeakObserver<string, PageEditItemViewData> = new WeakObserver();
}

export class PageEditItemViewData {
  @Track public pageScale: number = 1;
  @Track public translateX: number = 0;
}
