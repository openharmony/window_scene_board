/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
  CommonConstants,
  DeviceState,
  EditModeConstants,
  EditModeUtils,
  EventConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  layoutConfigManager,
  LayoutViewModel,
  PageInfoManager,
  ReceiveEventInfo,
  StyleConstants
} from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, localEventManager, WallpaperColorManager } from '@ohos/frameworkwrapper';
import { DropAnimationDestination, DropAnimationListener, dropAnimationObserver, } from '@ohos/componentanimator';
import { DragConstants } from '@ohos/commonconstants';
import { DragItemPosition } from '@ohos/componentdrag';
import { launcherStatusUtil } from '@ohos/windowscene';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import DesktopEditStyleConstants from '../common/constants/EditModeStyleConstants';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import {
  PageDesktopGridStyleConfig
} from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { FormStyleConfig, FormViewModel } from '@ohos/form';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import {
  DisplayCountViewModel,
  PageEditViewModel,
  DragProxyManager,
  DragHandlerType,
  IDesktopDragHandler,
} from '@ohos/launchercommon/Index';
import { FolderStyleManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'SwiperPageWhiteBoxComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct SwiperPageWhiteBoxComponent {
  @Prop singleContext?: SingleContext;
  @Prop isAddBlankPage: boolean = false;
  @Prop mFoldPaddingLeft: number = 0;
  @Prop mFoldPaddingRight: number = 0;
  @Prop @Watch('onDragItemLeave') mShowWhiteBoxReason: string = '';
  @State mShowWhiteBox: boolean = false;
  @StorageLink('dragItemInfo') dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  @StorageLink('isDrag') @Watch('onDragChange') isDrag: boolean = false;
  @State isInDropAnimation: boolean = false;
  @State mMargin: number = 0;
  @State mDragItemWidth: number = 0;
  @State mDragItemHeight: number = 0;
  @State mWhiteBox: number[] =
    [StyleConstants.EDIT_MODE_DEFAULT_WHITE_BOX_POSITION, StyleConstants.EDIT_MODE_DEFAULT_WHITE_BOX_POSITION];
  @State mIconSize: number = 0;
  @StorageProp('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageProp('desktopIconChange') @Watch('onThemeChange') desktopIconChange: number = 0;
  @State mIconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;
  @Prop @Watch('initConfig') folderStatus: number = DeviceState.DEFAULT_STATE;
  @Prop @Watch('initConfig') mIsPortrait: boolean = true;
  @State isShowCurrent: boolean = false;
  private mWhiteBoxBorderWidth: string = StyleConstants.SQUEEZE_BORDER_WIDTH;
  private mGridWidth: number = 0;
  @State fallWhiteBoxWidth: number = this.mGridWidth;
  // 宫格区offset
  @Prop offSetY: number = 0;
  // 落位白板Y轴偏移
  @State whiteBoxTranslateY: number = 0;
  private mGridHeight: number = 0;
  private getIndexInSwiper: Function = (): number => 0;
  /** 落位白框组件所在页index */
  @Prop @Watch('onIndexInSwiperChange') indexInSwiper: number = 0;
  /** 落位白框组件显示事件监听id */
  private fallItemEventId: string = '';
  /** 落位白框组件是否已上树 */
  private isAppeared: boolean = false;

  private mPageDesktopStyleConfig: PageDesktopGridStyleConfig = layoutConfigManager.getStyleConfig(
    PageDesktopGridStyleConfig.APP_GRID_STYLE_CONFIG,
    PageDesktopGridStyleConfig.getInstance(this.singleContext).getFeatureName()
  );
  private mMarginTop: number = 0;
  private isDragScene: boolean = false;
  private mLastAnimatePosition?: DragItemPosition;
  private mOriginPosition?: DragItemPosition;
  private isOuterDesktop: boolean = false;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private currentChangeCallback: Function = (): void => this.showCurrentChange();
  private onDesktopModeChangeEvent: Function = (): void => this.editModeStateChange();
  private fallItemCallback: Function =
    (isShow: boolean, endPosition?: DragItemPosition): void => this.onEventhubFallItemEvent(isShow, endPosition);
  private dropAnimationListener: DropAnimationListener = {
    onDropAnimationStart: (target: DropAnimationDestination) => {
      if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
        return;
      }
      if (target === DropAnimationDestination.DESKTOP) {
        this.isInDropAnimation = true;
      }
    },
    onDropAnimationEnd: (target: DropAnimationDestination) => {
      if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
        return;
      }
      if (target === DropAnimationDestination.DESKTOP) {
        this.isInDropAnimation = false;
        this.changeWhiteBoxShow(false);
      }
    },
  }

  private initConfig() {
    this.mMargin = this.mPageDesktopStyleConfig.mMargin as number;
    this.mMarginTop = this.mPageDesktopStyleConfig.mDesktopMarginTop as number -
      LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight();
    this.mGridWidth = this.mPageDesktopStyleConfig.mGridWidth as number;
    this.mGridHeight = this.mPageDesktopStyleConfig.mGridHeight as number;
    this.mIconSize = this.mPageDesktopStyleConfig.mIconSize as number;
    this.mIconRadius = this.mPageDesktopStyleConfig.mIconRadius;
    if (!DeviceHelper.isBigScreenMachine()) {
      const screenWidth = AppStorage.get<number>('screenWidth') as number ?? 0;
      const displayCount: number = DisplayCountViewModel.getInstance().getDisplayCount();
      this.fallWhiteBoxWidth = screenWidth / displayCount;
    }
    this.whiteBoxTranslateY = PageEditViewModel.getInstance().getWhiteBoxTranslateY();
  }

  private readonly mPageDeskDropEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: number) => {
      if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
        return;
      }
      log.showInfo(`receive event: ${event}, params: ${params}, page: ${this.getIndexInSwiper()}`);
      if (event === EditModeConstants.EVENT_PAGEDESK_DROP_FINISHED) {
        this.animateToShowFallBox(false, false);
        this.mShowWhiteBoxReason = '';
      }
    }
  };

  private onIndexInSwiperChange(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    if (this.isAppeared) {
      log.showInfo(`onIndexInSwiperChange ${this.getIndexInSwiper()}`)
      if (this.fallItemEventId !== '') {
        this.desktopContext?.eventHub.off(this.fallItemEventId, this.fallItemCallback);
      }
      this.updateFallItemEventId();
      this.desktopContext?.eventHub.on(this.fallItemEventId, this.fallItemCallback);
    }
  };

  private updateFallItemEventId(): void {
    this.fallItemEventId = `rect${this.getIndexInSwiper()}`;
  }

  private initEventhubEvent(): void {
    this.updateFallItemEventId();
    this.desktopContext?.eventHub.on(this.fallItemEventId, this.fallItemCallback);
    log.showInfo(`onEventhubFallItemEvent for Item ${this.fallItemEventId}`);

    this.desktopContext?.eventHub.on(DragConstants.WHITE_BOX_CHANGE_EVENT, this.currentChangeCallback);
  }

  private updateGridItemWhiteEdgeParams(msg: string, isShow: boolean, endPosition?: DragItemPosition): void {
    log.showDebug('%{public}s updateGridItemWhiteEdgeParams, getIndexInSwiper(): %{public}d, pageIndex: %{public}d, isShow: %{public}s, isDragScene: %{public}s',
      msg, this.getIndexInSwiper(), desktopUtil.getPageIndexValue(), isShow, this.isDragScene);

    if (!isShow || CheckEmptyUtils.isEmpty(this.dragItemInfo) || CheckEmptyUtils.isEmpty(endPosition) || !this.isDrag) {
      this.isDragScene = false;
      this.mOriginPosition = undefined;
      this.animateToShowFallBox(false, false);
      return;
    }

    // 相同位置的落位框不重复执行动效，避免落位框闪动
    if (this.judgeSamePosition(this.mOriginPosition, endPosition) && this.mShowWhiteBox) {
      return;
    }
    this.mOriginPosition = endPosition;
    this.updateFallWhitBoxArea();
    // 连续拖拽时落位框动效场景
    if (this.isDragScene) {
      this.animateToShowFallBox(false, true, endPosition);
    } else {
      this.updateFallWhiteBoxPosition(endPosition as DragItemPosition);
      this.animateToShowFallBox(true, false);
      this.isDragScene = true;
    }
    log.showDebug(`updateGridItemWhiteEdgeParams end, isDragScene: ${this.isDragScene} mWhiteBox:${this.mWhiteBox}`);
  }

  private animateToShowFallBox(isShow: boolean, isDragScene: boolean, endPosition?: DragItemPosition) {
    this.mLastAnimatePosition = endPosition;

    // 属性未发生变化时，跳过动效，避免冗余动效
    if (this.mShowWhiteBox === isShow && (!this.isDrag || !isDragScene)) {
      log.showInfo(`skip animateToShowFallBox`);
      return;
    }

    animateTo({
      duration: isDragScene ? 1 : 250,
      curve: Curve.Sharp,
      onFinish: () => {
        if (isDragScene && this.isDrag) {
          if (this.judgeSamePosition(this.mLastAnimatePosition, endPosition)) {
            this.updateFallWhiteBoxPosition(endPosition as DragItemPosition);
            animateTo({
              duration: 250,
              curve: Curve.Sharp
            }, () => {
              this.mShowWhiteBox = true;
            })
          }
        }
      }
    }, () => {
      this.mShowWhiteBox = isShow;
    });
  }

  private judgeSamePosition(startPosition?: DragItemPosition, endPosition?: DragItemPosition): boolean {
    if (
      !startPosition ||
      CheckEmptyUtils.isEmpty(startPosition) ||
      !endPosition ||
      CheckEmptyUtils.isEmpty(endPosition)
    ) {
      return false;
    }
    return startPosition.page === endPosition.page &&
      startPosition.row === endPosition.row &&
      startPosition.column === endPosition.column &&
      startPosition.x === endPosition.x &&
      startPosition.y === endPosition.y;
  }

  private updateFallWhiteBoxPosition(endPosition: DragItemPosition): void {
    let displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    const screenWidth = AppStorage.get<number>('screenWidth') as number ?? 0;
    if (editModeManager.isInEditMode()) {
      // 编辑模式、取grid的坐标计算白框的position
      const coordinates = EditModeUtils.getCoordinates();
      const coordinate = coordinates[0];
      const scale = EditModeUtils.getDesktopScale();
      this.mMarginTop = this.mPageDesktopStyleConfig.mDesktopMarginTop as number -
      LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight();
      if (this.isOuterDesktop) {
        this.mMarginTop -= CommonConstants.OUTER_SCREEN_OFFSET;
      }
      const top = coordinate[1] - this.mMarginTop * scale;
      const mIconSize = this.mIconSize / 2 * scale;
      this.mWhiteBox[1] = (endPosition.y as number - top - mIconSize) / scale;
      const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
        .get(TAG, DragHandlerType.DESKTOP) as IDesktopDragHandler;
      const pageIndex: number =  dragProxy.getCurrentPageIndex();
      let pagePosition = pageIndex % displayCount;
      if (RTLUtil.isRTL()) {
        pagePosition = displayCount - 1 - pagePosition;
      }
      this.mWhiteBox[0] = (screenWidth * pagePosition / displayCount + this.mFoldPaddingLeft +
        endPosition.x as number - coordinates[pagePosition][0]) / scale - this.mIconSize / 2 -
        EditModeUtils.getPrevNextMargin(this.isOuterDesktop);
      log.showInfo(`updateFallWhiteBoxPosition InEditMode mWhiteBox=${this.mWhiteBox} endPosition=${endPosition.x},${endPosition.y} mFoldPaddingLeft= ${this.mFoldPaddingLeft}`);
      return;
    }
    this.mWhiteBox[0] = endPosition.x as number - this.mIconSize / 2 - this.mMargin;
    // 由于swiperPage是从状态栏位置开始，因此需要额外减去状态栏高度
    const sysUITopHeight = LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight();
    this.mWhiteBox[1] = endPosition.y as number - this.mIconSize / 2 - sysUITopHeight;
    log.showInfo(`updateFallWhiteBoxPosition mWhiteBox=${this.mWhiteBox} endPosition=${endPosition.x},${endPosition.y}`);
  }

  private updateFallWhitBoxArea() {
    // 根据拖拽元素的area设置落位白框的长宽
    let mFormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
    const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
      .get(TAG, DragHandlerType.DESKTOP) as IDesktopDragHandler;
    let dragItems: GridLayoutItemInfo[] | undefined = dragProxy.getDragItems();

    if (dragItems == null) {
      return;
    }
    let dragItemInfo = dragItems[0];
    if (dragItemInfo && dragItemInfo.area && dragItemInfo.area.length === 2) {
      // PC大文件夹落位区域单独计算
      if (dragItemInfo.typeId === CommonConstants.TYPE_REGION_FOLDER) {
        const size: [number, number] = mFormStyleConfig.getRegionFolderDropSize(dragItemInfo.area);
        this.mDragItemWidth = size[0];
        this.mDragItemHeight = size[1];
      } else {
        this.mDragItemWidth = FolderStyleManager.getInstance().getWidthByArea(dragItemInfo.area) ||
          mFormStyleConfig.getSize(dragItemInfo.area[0]);
        if (dragItemInfo.isFormDimension1x4) {
          log.showInfo('dragItemInfo isFormDimension1x4 true');
          const padding: number = AppStorage.get<number>('itemPadding') ?? 0;
          this.mDragItemHeight = GridLayoutUtil.getGridHeight() - padding * 2;
        } else {
          this.mDragItemHeight = mFormStyleConfig.getSize(dragItemInfo.area[1]);
        }
      }
      log.showInfo('updateWhitBox area:%{TypeId}s [%{public}d %{public}d] width: %{public}d height: %{public}d',
        dragItemInfo.typeId, dragItemInfo.area[0], dragItemInfo.area[1], this.mDragItemWidth, this.mDragItemHeight);
      if (dragItemInfo.typeId === CommonConstants.TYPE_CARD) {
        // 是否是快捷图标
        let isShortcutForm: boolean = !CheckEmptyUtils.isEmpty(this.dragItemInfo.shortcutInfo);
        this.mIconRadius = mFormStyleConfig.getFormBorderRadius(this.dragItemInfo.cardDimension, isShortcutForm);
      } else {
        this.mIconRadius = this.mPageDesktopStyleConfig.mIconRadius;
      }
    }
  }

  private onEventhubFallItemEvent(isShow: boolean, endPosition?: DragItemPosition): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    this.updateGridItemWhiteEdgeParams('update by event', isShow, endPosition);
  }

  private onThemeChange(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    this.mIconSize = this.mPageDesktopStyleConfig.mIconSize;
    this.mIconRadius = this.mPageDesktopStyleConfig.mIconRadius;
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear getIndexInSwiper():%{public}d', this.getIndexInSwiper());
    this.initConfig();
    this.initEventhubEvent();
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.registerDesktopDropFinishEvent(this.mPageDeskDropEventListener);
    dropAnimationObserver.registerDropAnimationListener(this.dropAnimationListener);
    this.isAppeared = true;
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear getIndexInSwiper():%{public}d', this.getIndexInSwiper());
    this.desktopContext?.eventHub.off(this.fallItemEventId, this.fallItemCallback);

    this.desktopContext?.eventHub.off(DragConstants.WHITE_BOX_CHANGE_EVENT, this.currentChangeCallback);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    localEventManager.unregisterEventListener(this.mPageDeskDropEventListener);
    dropAnimationObserver.unregisterDropAnimationListener(this.dropAnimationListener);
    this.isAppeared = false;
  }

  private onDragChange(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    log.showInfo('onDragChange, pageIndex:%{public}d, isDragScene:%{public}s, isDrag:%{public}s, showWhiteBox:%{public}s',
      this.getIndexInSwiper(), this.isDragScene, this.isDrag, this.mShowWhiteBox);
    if (this.isDrag) {
      // 起拖时让当前页落位白框上树,折叠屏场景则是当前可见的两页上树
      this.showCurrentChange();
    } else {
      this.isDragScene = false;
      if (this.mShowWhiteBox) {
        this.animateToShowFallBox(false, false);
      }

      // 落位时无落位动效让落位白框下树
      if (!this.isInDropAnimation) {
        this.changeWhiteBoxShow(false);
      }
    }
  }

  /**
   * 编辑模式切换时缓慢更新宫格偏移及落位白板偏移
   */
  private editModeStateChange(): void {
    animateTo({
      curve: EditModeConstants.CHANGE_DESKMODE_CURVE,
      delay: editModeManager.isInEditMode() ? EditModeStyleConstants.DESKTOP_MODE_CHANGE_DELAY : 0
    }, () => {
      this.whiteBoxTranslateY = PageEditViewModel.getInstance().getWhiteBoxTranslateY();
    });
  }

  private showCurrentChange(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
      .get(TAG, DragHandlerType.DESKTOP) as IDesktopDragHandler;
    let dragPageIndex: number = dragProxy.getCurrentPageIndex();

    const currentPage: number = dragProxy.getDragPageIndex();
    let boxPageIndex: number = this.getIndexInSwiper();
    let displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    dragPageIndex = dragPageIndex - dragPageIndex % displayCount;
    boxPageIndex = boxPageIndex - boxPageIndex % displayCount;
    this.changeWhiteBoxShow(dragPageIndex === boxPageIndex);
  }

  private changeWhiteBoxShow(isShowCurrent: boolean): void {
    if (isShowCurrent === this.isShowCurrent) {
      return;
    }
    this.isShowCurrent = isShowCurrent;
  }

  // 卡片或大文件夹拖拽到桌面外需要落回原位，消除上次拖动落位位置白框并在原位增加白框
  onDragItemLeave(): void {
    log.showDebug(`onDragLeave, pageIndex: ${this.getIndexInSwiper()}, mShowWhiteBoxReason: ${this.mShowWhiteBoxReason}`);
    if (CheckEmptyUtils.isEmpty(this.mWhiteBox) || CheckEmptyUtils.isEmpty(this.dragItemInfo)) {
      return;
    }

    if (!CheckEmptyUtils.isEmpty(this.mShowWhiteBoxReason)) {
      log.showInfo(`onDragLeave, update mShowWhiteBoxReason: ${this.mShowWhiteBoxReason}`);
      this.animateToShowFallBox(false, false);
    }
    log.showDebug(`onDragLeave update whiteBox: ${this.mWhiteBox}`);
  }

  registerDesktopDropFinishEvent(listener: Object): void {
    localEventManager.registerEventListener(
      listener,
      [EditModeConstants.EVENT_PAGEDESK_DROP_FINISHED]
    );
  }

  build() {
    if (this.isShowCurrent) {
      Stack() {
        FallWhiteBox({
          mShowWhiteBox: this.mShowWhiteBox,
          mWhiteBoxBorderWidth: this.mWhiteBoxBorderWidth,
          mDragItemWidth: this.mDragItemWidth,
          mDragItemHeight: this.mDragItemHeight,
          mWhiteBox: this.mWhiteBox,
          iconRadius: this.mIconRadius,
          getIndexInSwiper: this.getIndexInSwiper,
          isOuterDesktop: this.isOuterDesktop
        })
      }
      .position({ x: 0 })
      .margin({ left: this.mFoldPaddingLeft + this.mMargin, right: this.mFoldPaddingRight + this.mMargin })
      .id('SwiperPageStack_SwiperPageWhiteBox')
      .width(this.fallWhiteBoxWidth - this.mMargin * 2)
      .height(this.mGridHeight + this.mMarginTop)
      .translate({
        x: this.isAddBlankPage ? (PageEditViewModel.getInstance().getScreenXTranslate() / 2) : 0,
        y: this.whiteBoxTranslateY
      })
    }
  }
}

@Component
struct FallWhiteBox {
  @Prop mShowWhiteBox: boolean = false;
  @Prop mWhiteBoxBorderWidth: string = StyleConstants.SQUEEZE_BORDER_WIDTH;
  @Prop mDragItemWidth: number = 0;
  @Prop mDragItemHeight: number = 0;
  @Prop mWhiteBox: number[] = [
    StyleConstants.EDIT_MODE_DEFAULT_WHITE_BOX_POSITION,
    StyleConstants.EDIT_MODE_DEFAULT_WHITE_BOX_POSITION
  ];
  @Prop iconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;
  @State hasEnterHotArea: boolean = false;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private mBorderColor: string = DesktopEditStyleConstants.WHITE_BOX_BORDER_COLOR_LIGHT;
  private mBgColor: string = DesktopEditStyleConstants.WHITE_BOX_BG_COLOR_LIGHT;
  private getIndexInSwiper: Function = (): number => 0;
  private isOuterDesktop: boolean = false;
  /** currColorMode 深浅模式的判断 */
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;

  aboutToAppear(): void {
    this.desktopContext?.eventHub.on(`${EditModeConstants.EVENT_EDIT_MODE_ENTER_HOT_AREA}${this.getIndexInSwiper()}`,
      (hasEnterHotArea: boolean): void => {
        if (launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
          this.hasEnterHotArea = hasEnterHotArea
        }
      });
    this.initColor();
  }

  aboutToDisappear(): void {
    this.desktopContext?.eventHub.off(`${EditModeConstants.EVENT_EDIT_MODE_ENTER_HOT_AREA}${this.getIndexInSwiper()}`);
  }

  private initColor(): void {
    let isLightWallpaper = WallpaperColorManager.getInstance().isLightWallpaper(this.isOuterDesktop);
    log.showInfo(`initColor isLightWallpaper:${isLightWallpaper}`);
    if (isLightWallpaper) {
      this.mBorderColor = DesktopEditStyleConstants.WHITE_BOX_BORDER_COLOR_DARK;
      this.mBgColor = DesktopEditStyleConstants.WHITE_BOX_BG_COLOR_DARK;
    }
  }

  build() {
    if (DeviceHelper.isPC()) {
      Column()
      .border({
        width: DesktopEditStyleConstants.SQUEEZE_BORDER_WIDTH,
        color: StyleConstants.SWIPER_PAGE_WHITE_COMPONENT_COLOR
      })
      .outline(
        {
          width: DesktopEditStyleConstants.SQUEEZE_BORDER_WIDTH,
          color: this.currColorMode === 1 ? StyleConstants.SWIPER_PAGE_WHITE_COMPONENT_OUTLINE_BRIGHT_COLOR :
            StyleConstants.SWIPER_PAGE_WHITE_COMPONENT_OUTLINE_DARK_COLOR,
          radius: this.iconRadius + StyleConstants.DEFAULT_1
        }
      )
      .key(`FallWhitBox`)
      .borderRadius(this.iconRadius)
      .backgroundColor($r('sys.color.ohos_id_color_component_normal'))
      .width(this.mDragItemWidth)
      .height(this.mDragItemHeight)
      .position({ x: this.mWhiteBox[0], y: this.mWhiteBox[1] })
      .opacity(this.mShowWhiteBox ? 1 : 0)
    } else {
      Column()
        .border({
          width: this.mWhiteBoxBorderWidth,
          color: this.mBorderColor,
        })
        .borderRadius(this.iconRadius)
        .width(this.mDragItemWidth)
        .height(this.mDragItemHeight)
        .backgroundColor(this.mBgColor)
        .position({ x: this.mWhiteBox[0], y: this.mWhiteBox[1] })
        .opacity(this.mShowWhiteBox ? 1 : 0)
        .visibility(this.hasEnterHotArea ? Visibility.Hidden : Visibility.Visible)
    }
  }
}