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

import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil, desktopUtil } from '@ohos/componenthelper';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import {
  DeviceState,
  EditModeUtils,
  StyleConstants,
  EventConstants,
  EditModePageStaticData,
  EditModeConstants,
  lockLayoutManager,
} from '@ohos/launchercommon';
import { EditModeViewState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeViewState';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';
import { editModeViewManager } from '../manager/EditModeViewManager';
import {
  pageEditManager,
  EditModePageActionEnum,
  PageEditViewModel,
  PageDragManager,
  DisplayCountViewModel,
  DragProxyManager,
  DragHandlerType,
  IDesktopDragHandler,
} from '@ohos/launchercommon/Index';
import EditModeDragAnimatePage from './EditModeDragAnimatePage';
import { EditModeAccessibilityUtil } from '@ohos/launchercommon/src/main/ets/editmode/utils/EditModeAccessibilityUtil';

const TAG: string = 'EditModePageBackplane';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式singlePage背板
 */
@Component
export default struct EditModePageBackplane {
  @Prop index: number = 0;
  @Prop swiperKey: number = 0;
  @State editModeViewState: EditModeViewState = editModeManager.getEditModeViewState();
  @State bgBorderRadius: number = 0;
  @State bgHeight: number = 0;
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  @StorageLink('folderStatus') folderStatus: number = DeviceState.DEFAULT_STATE;
  private pageEditViewModel: PageEditViewModel = PageEditViewModel.getInstance();
  private displayCnt: number = DisplayCountViewModel.getInstance().getDisplayCount();
  private onEditModeAnimationFinishEvent: Function = (): void => this.doUpdateCachedCountFlag();
  // 进入编辑模式动效是否完成
  @State enterEditModeFinish: boolean = false;
  // 当前页是否显示在桌面上
  private isCurrentPageShow: boolean = false;

  aboutToAppear(): void {
    let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    let screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    let workSpaceHeight: number = AppStorage.get<number>('workSpaceHeight') as number;
    this.bgBorderRadius = EditModeUtils.getBgBorderRadius(screenWidth);
    this.bgHeight = EditModeUtils.getBackgroundHeight(screenHeight, screenWidth, workSpaceHeight);
    log.showInfo(`aboutToAppear bgHeight ${this.bgHeight}, swiperKey: ${this.swiperKey}`);
    GlobalContext.getContext()?.eventHub.on(EventConstants.EVENT_CHANGE_CHANGE_EDIT_MODE_ANIMATION_FINISH,
      this.onEditModeAnimationFinishEvent);
    const currentPage = desktopUtil.getPageIndexValue();
    const currentPages = EditModeUtils.getCurrentShowingPage(currentPage, this.displayCnt);
    // 在进入编辑模式动效中当前页使用中间页拉伸300%宽度的背板，其余页不使用
    this.isCurrentPageShow = currentPages.indexOf(this.index) !== -1;
  }

  aboutToDisappear(): void {
    GlobalContext.getContext()?.eventHub.off(EventConstants.EVENT_CHANGE_CHANGE_EDIT_MODE_ANIMATION_FINISH,
      this.onEditModeAnimationFinishEvent);
  }

  doUpdateCachedCountFlag(): void {
    // 在进入编辑模式动效后恢复两边页面的中间页拉伸300%宽度的背板
    this.enterEditModeFinish = editModeManager.isInEditMode();
  }

  private getBorderRadius(): BorderRadiuses {
    const displayCnt = DisplayCountViewModel.getInstance().getDisplayCount();
    if (this.index % displayCnt === 0) {
      return RTLUtil.isRTL() ? { topRight: this.bgBorderRadius, bottomRight: this.bgBorderRadius } :
        { topLeft: this.bgBorderRadius, bottomLeft: this.bgBorderRadius }
    } else if ((this.index + 1) % displayCnt === 0) {
      return RTLUtil.isRTL() ? { topLeft: this.bgBorderRadius, bottomLeft: this.bgBorderRadius } :
        { topRight: this.bgBorderRadius, bottomRight: this.bgBorderRadius }
    } else {
      return {};
    }
  }

  /**
   * 使用中间页拉伸300%宽度的背板的场景：
   * 1、超大屏设备展开态当前显示页在进入编辑模式动效中
   * 2、超大屏设备展开态进入编辑模式动效后
   * */
  private isCurrentPageShowInTriFoldEditMode(): boolean {
    return this.displayCnt === 3 && this.index % this.displayCnt === 1 &&
      (this.enterEditModeFinish || this.isCurrentPageShow);
  }

  /**
   * 超大屏设备展开态当前显示页在进入编辑模式动效中左右两页直接下树隐藏不显示，在进入编辑模式动效后，恢复上树
   * */
  private isTriFoldDeviceNotMiddlePage(): boolean {
    return this.displayCnt === 3 && this.index % this.displayCnt !== 1;
  }

  /**
   * 拖拽组件
   */
  @Builder
  EditModeAnimateDragPageBuilder() {
    EditModeDragAnimatePage({
      index: this.index,
      swiperKey: this.swiperKey,
      isOuter: false
    })
  }

  build() {
    Row() {
    }
    .id(EditModeAccessibilityUtil.getEditModeBackPlaneId(this.swiperKey))
    .width(this.isCurrentPageShowInTriFoldEditMode() ?
      StyleConstants.PERCENTAGE_300 : StyleConstants.PERCENTAGE_100)
    .height(this.bgHeight)
    .translate({y: this.editModeSingePageViewData.getEditModeBgTranslateY()})
    .backgroundColor(editModeManager.getEditModeStyleConfig().pageEditBgColor)
    .visibility((this.isTriFoldDeviceNotMiddlePage() && this.isCurrentPageShow && !this.enterEditModeFinish) ?
      Visibility.None : Visibility.Visible)
    .opacity((this.isTriFoldDeviceNotMiddlePage() && this.enterEditModeFinish) ?
      0.01 : this.editModeSingePageViewData.getSingePageBackgroundOpacity())
    .saturate(this.editModeSingePageViewData.getSingePageBackgroundSaturate())
    .borderRadius(this.folderStatus === DeviceState.DEFAULT_STATE || this.isCurrentPageShowInTriFoldEditMode() ?
      this.bgBorderRadius : this.getBorderRadius())
    .accessibilityDescription(EditModeAccessibilityUtil.getBackPlaneAccessibilityText(this.index))
    .gesture(GestureGroup(GestureMode.Exclusive,
      LongPressGesture({ duration: EditModeConstants.PAGE_DRAG_SNAPSHOT_TIME }),
      TapGesture()
        .onAction(() => {
          log.showInfo('EditMode back plane onclick');
          if (this.pageEditViewModel.isDragingPage()) {
            return;
          }
          if (pageEditManager.editModeEditPageData.handleEditPageState === EditModePageActionEnum.WAITTING_ACTION) {
            editModeManager.clickBlankSpace();
          }
        })
    ))
    .priorityGesture(
      // 拦截上滑手势，避免因上滑手势错误触发点击导致退出
      PanGesture(new PanGestureOptions({
        distance: EditModeStyleConstants.EDIT_MODE_BACKPLANE_PAN_GESTURE_MIN_DISTANCE,
        direction: PanDirection.Up
      }))
    )
    .parallelGesture(GestureGroup(GestureMode.Parallel,
      LongPressGesture({ repeat: false, duration: EditModeConstants.PAGE_DRAG_SNAPSHOT_TIME })
        .onAction((event: GestureEvent) => {
          if (lockLayoutManager.isLockLayout()) {
            return;
          }
          PageEditViewModel.getInstance()
            .onLongPressForSnapshot(() => this.EditModeAnimateDragPageBuilder(), event, this.index, this.swiperKey,
              false)
        })
        .onActionEnd((event: GestureEvent) => {
          if (lockLayoutManager.isLockLayout()) {
            return;
          }
          // 正常逻辑里会在触发拖拽的时候触发长按手势的ActionCancel, 所以actionEnd场景是长按时长不够,需要释放截图
          PageEditViewModel.getInstance().onLongPressForSnapshotEnd(event, this.swiperKey);
        }),
      LongPressGesture({ repeat: false, duration: EditModeConstants.PAGE_DRAG_ANI_TIME })
        .onAction(() => {
          if (lockLayoutManager.isLockLayout()) {
            lockLayoutManager.toastLockedLayout();
            return;
          }
          PageEditViewModel.getInstance().onLongPressForAnimate(this.index, this.getUIContext(), false)
        })
        .onActionEnd(() => {
          if (lockLayoutManager.isLockLayout()) {
            return;
          }
          PageEditViewModel.getInstance().onLongPressForAnimateEnd()
        })
      ,
      LongPressGesture({
        repeat: false,
        duration: EditModeConstants.PAGE_DRAG_ANI_TIME + EditModeConstants.PAGE_SCALE_DURATION * 2
      })
        .onAction((event: GestureEvent) => {
          if (lockLayoutManager.isLockLayout()) {
            return;
          }
          const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
            .get('pageDrag in EditMode', DragHandlerType.DESKTOP) as IDesktopDragHandler;
          const currentPage: number = dragProxy.getDragPageIndex();
          log.showInfo(`pageDrag start: PRE_DRAG_PAGE swiperKey:${this.swiperKey} index:${this.index} currentPage:${currentPage}`);
          EditModePageStaticData.editModeBgHeight = event.target.area.height as number;
          this.pageEditViewModel.updateEditModeBackGroundPointY(
            this.editModeSingePageViewData.getEditModeBgTranslateY(),
            editModeViewManager.getEditModeGridSwiperViewData().getGridSwiperScale(),
            editModeViewManager.getEditModeSingePageViewData().getSingePageSwiperScale(),
            false
          );
          // 加号页不可拖拽，隔离折叠屏、外屏场景
          if (
            editModeManager.isInEditMode() &&
             PageDragManager.getInstance().getRelativePages(currentPage).includes(this.index)
          ) {
            pageEditManager.dragPageData.dragPageState = EditModePageActionEnum.PRE_DRAG_PAGE;
            const uiContext: UIContext = this.getUIContext();
            PageEditViewModel.getInstance().onLongPressForDrag(
              event,
              this.index,
              this.swiperKey,
              false,
              uiContext
            );
          }
        }),
    ))
  }
}