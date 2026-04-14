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

import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ZoomHotArea } from '../common/FormZoomCommonType';
import { FormZoomManager } from '../common/FormZoomManager';
import { FormZoomUtil } from '../common/FormZoomUtil';
import { formZoomController } from '../viewModel/FormZoomController';

const TAG = 'FormZoomPreviewComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const BORDER_WIDTH: number = 1.5;
const OPACITY_DEFAULT: number = 0.2;
const HALF: number = 0.5;

/**
 * 调整卡片大小的预览组件
 */
@Component
export struct FormZoomPreviewComponent {
  @State snapshot?: image.PixelMap = undefined;
  @Prop mFormItemWidth: number;
  @Prop mFormItemHeight: number;
  @Prop mFormBorderRadius: number;
  private menuPreviewDragStarted: boolean = false;
  private mFormComponentId?: string;

  private hotAreaTouchHandler = (hotArea: ZoomHotArea) => {
    this.menuPreviewDragStarted = true;
    formZoomController.startDrag(hotArea);
    ContextMenu.close();
  }

  @Builder
  DragBarBuilder() {
    DragBarComponent()
      .offset({
        x: 0,
        y: -(this.mFormItemHeight - BORDER_WIDTH) * HALF
      })
    DragBarComponent()
      .offset({
        x: 0,
        y: (this.mFormItemHeight - BORDER_WIDTH) * HALF
      })
    DragBarComponent()
      .offset({
        x: -(this.mFormItemWidth - BORDER_WIDTH) * HALF,
        y: 0
      })
    DragBarComponent()
      .offset({
        x: (this.mFormItemWidth - BORDER_WIDTH) * HALF,
        y: 0
      })
  }

  aboutToAppear(): void {
    log.showInfo('FormZoomPreviewComponent about to appear');
    if (this.mFormComponentId) {
      this.snapshot = FormZoomManager.getInstance().getFormZoomSnapshot();
    }
  }

  aboutToDisappear(): void {
    log.showInfo('FormZoomPreviewComponent about to disappear');
    if (!this.menuPreviewDragStarted) {
      FormZoomManager.getInstance().reset();
    }
  }

  build() {
    Stack() {
      Stack() {
        // 卡片截图
        Image(this.snapshot)
          .draggable(false)
          .width('100%')
          .height('100%')
          .syncLoad(true)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .borderRadius(this.mFormBorderRadius)
          .objectFit(ImageFit.Contain)
        // 拖拽线框
        Column() {
        }
        .width('100%')
        .height('100%')
        .borderRadius(this.mFormBorderRadius)
        .borderWidth(BORDER_WIDTH)
        .borderColor('#0A59F7')
        .hitTestBehavior(HitTestMode.None)
        // 拖拽把手
        this.DragBarBuilder()
        // 拖拽热区
        ForEach(FormZoomUtil.HOT_AREA_LIST, (hotArea: ZoomHotArea) => {
          HotAreaPreviewComponent({
            mHotArea: hotArea,
            touchHandler: this.hotAreaTouchHandler
          })
        }, (item: ZoomHotArea) => item.position.toString())
      }
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width(this.mFormItemWidth)
    .height(this.mFormItemHeight)
    .hitTestBehavior(HitTestMode.Transparent)
    .alignRules({
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
  }
}

/**
 * 拖拽把手：边框中心圆点
 */
@Component
export struct DragBarComponent {
  build() {
    Stack() {
      Circle({ width: 16, height: 16 }).fill(0xFFFFFF).opacity(OPACITY_DEFAULT)
      Circle({ width: 16, height: 16 }).fill(0x0A59F7).opacity(OPACITY_DEFAULT)
      Circle({ width: 6, height: 6 }).fill(0x0A59F7)
    }
    .width(16)
    .height(16)
  }
}

/**
 * 拖拽热区，仅用于展示及点击 ，用于菜单预览
 */
@Component
export struct HotAreaPreviewComponent {
  private mHotArea: ZoomHotArea = FormZoomUtil.AREA_NONE;
  private touchHandler?: (hotArea: ZoomHotArea) => void;

  build() {
    Column() {
    }
    .width(this.mHotArea.width)
    .height(this.mHotArea.height)
    .offset({ x: this.mHotArea.offsetX, y: this.mHotArea.offsetY })
    .onTouch((event?: TouchEvent) => {
      if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
        this.touchHandler?.(this.mHotArea);
      }
    })
  }
}