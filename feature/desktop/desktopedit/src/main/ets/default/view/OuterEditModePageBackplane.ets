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
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { DeviceState,
  EditModeConstants,
  EditModePageStaticData,
  EditModeUtils
} from '@ohos/launchercommon';
import { EditModeViewState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeViewState';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';
import { editModeViewManager } from '../manager/EditModeViewManager';
import {
  EditModePageActionEnum,
  PageDragManager,
  pageEditManager,
  PageEditViewModel,
  DragProxyManager,
  DragHandlerType,
  IDesktopDragHandler,
} from '@ohos/launchercommon/Index';
import EditModeDragAnimatePage from './EditModeDragAnimatePage';

const TAG: string = 'OuterEditModePageBackplane';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 扩展新形态小折叠产品外屏编辑模式singlePage背板
 */
@Component
export default struct OuterEditModePageBackplane {
  @Prop index: number = 0;
  @State editModeViewState: EditModeViewState = editModeManager.getEditModeViewState();
  @State bgBorderRadius: number = 0;
  @State bgHeight: number = 0;
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  @StorageLink('folderStatus') folderStatus: number = DeviceState.DEFAULT_STATE;
  @State outerBgSize: number = 0;
  @Prop swiperKey: number = 0;
  private pageEditViewModel: PageEditViewModel = PageEditViewModel.getInstance();
  private outerBorderRadius: number = 18;
  private outerTranslateY: number = -10;

  aboutToAppear(): void {
    let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    let screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    let workSpaceHeight: number = AppStorage.get<number>('workSpaceHeight') as number;
    this.bgBorderRadius = this.outerBorderRadius / EditModeUtils.calEditModeScale(screenWidth);
    this.bgHeight = EditModeUtils.getBackgroundHeight(screenHeight, screenWidth, workSpaceHeight);
    this.outerBgSize = EditModeUtils.getOuterBackgroundSize(screenWidth);
  }

  /**
   * 拖拽组件
   */
  @Builder
  EditModeAnimateDragPageBuilder() {
    EditModeDragAnimatePage({
      index: this.index,
      swiperKey: this.swiperKey,
      isOuter: true
    })
  }

  build() {
    Row() {
    }
    .id('single_page_background_outer')
    .width(this.outerBgSize)
    .height(this.outerBgSize)
    .translate({
      y: this.outerTranslateY
    })
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .opacity(this.editModeSingePageViewData.getSingePageBackgroundOpacity())
    .saturate(this.editModeSingePageViewData.getSingePageBackgroundSaturate())
    .borderRadius(this.folderStatus === DeviceState.DEFAULT_STATE ? this.bgBorderRadius : this.index % 2 === 0 ?
      { topLeft: this.bgBorderRadius, bottomLeft: this.bgBorderRadius } :
      { topRight: this.bgBorderRadius, bottomRight: this.bgBorderRadius })
    .onClick(() => {
      log.showInfo('EditMode back plane onclick');
      editModeManager.clickBlankSpace();
    })
    .priorityGesture(
      // 拦截上滑手势，避免因上滑手势错误触发点击导致退出
      PanGesture(new PanGestureOptions({
        distance: EditModeStyleConstants.EDIT_MODE_BACKPLANE_PAN_GESTURE_MIN_DISTANCE,
        direction: PanDirection.Up
      }))
    )
    .parallelGesture(GestureGroup(GestureMode.Parallel,
      LongPressGesture({ repeat: false, duration: EditModeConstants.PAGE_DRAG_SNAPSHOT_TIME })
        .onAction((event: GestureEvent) => PageEditViewModel.getInstance()
          .onLongPressForSnapshot(() => this.EditModeAnimateDragPageBuilder(), event, this.index, this.swiperKey, true)
        )
        .onActionEnd((event: GestureEvent) => {
          // 正常逻辑里会在触发拖拽的时候触发长按手势的ActionCancel, 所以actionEnd场景是长按时长不够,需要释放截图
          PageEditViewModel.getInstance().onLongPressForSnapshotEnd(event, this.swiperKey);
        }),
      LongPressGesture({ repeat: false, duration: EditModeConstants.PAGE_DRAG_ANI_TIME })
        .onAction(() => PageEditViewModel.getInstance().onLongPressForAnimate(this.index, this.getUIContext(), true))
        .onActionEnd(() => PageEditViewModel.getInstance().onLongPressForAnimateEnd())
      ,
      LongPressGesture({
        repeat: false,
        duration: EditModeConstants.PAGE_DRAG_ANI_TIME + EditModeConstants.PAGE_SCALE_DURATION * 2
      })
        .onAction((event: GestureEvent) => {
          const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
            .get('pageDrag in EditMode', DragHandlerType.DESKTOP) as IDesktopDragHandler;
          const currentPage: number = dragProxy.getDragPageIndex();
          log.showInfo(`pageDrag start: PRE_DRAG_PAGE swiperKey:${this.swiperKey} index:${this.index} currentPage:${currentPage}`);
          EditModePageStaticData.editModeBgHeight = event.target.area.height as number;
          this.pageEditViewModel.updateEditModeBackGroundPointY(
            this.editModeSingePageViewData.getEditModeBgTranslateY(),
            editModeViewManager.getEditModeGridSwiperViewData().getGridSwiperScale(),
            editModeViewManager.getEditModeSingePageViewData().getSingePageSwiperScale(),
            true
          );
          if (
            editModeManager.isInEditMode() &&
            PageDragManager.getInstance().getRelativePages(currentPage).includes(this.index)
          ) {
            pageEditManager.dragPageData.dragPageState = EditModePageActionEnum.PRE_DRAG_PAGE;
            PageEditViewModel.getInstance().onLongPressForDrag(
              event,
              this.index,
              this.swiperKey,
              true
            );
          }
        }),
    ))
  }
}