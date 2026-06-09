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

import { curves, LengthMetrics } from '@kit.ArkUI';
import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragEventCallback } from '@ohos/componentdrag';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { PcStatusBarDragMgr } from '../manager/PcStatusBarDragMgr';
import { Constants } from '../common/Constants';

const TAG = 'PcTrayItemDropFrame';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct PcTrayItemDropFrame {
  @State mWhiteBoxX: number = 0;
  @State mWhiteBoxY: number = 0;
  @State mShowWhiteBox: boolean = false;
  private mPcStatusBarDragMgr: PcStatusBarDragMgr = PcStatusBarDragMgr.getInstance();
  private mDragEventCallback: DragEventCallback = {};
  private startTranslatePosition: number[] = [];
  private currentTranslatePosition: number[] = [];
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @State iconImage: image.PixelMap | undefined = undefined;
  private translateCurve: curves.ICurve = curves.interpolatingSpring(0.5, 1, 228, 30);

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.initDragEventCallback();
    this.registerDragEvent();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.unRegisterDragEvent();
  }

  private registerDragEvent(): void {
    log.showInfo('registerDragEvent');
    this.mPcStatusBarDragMgr.registerDragEvent(this.mDragEventCallback, Constants.PC_TRAY_DROP_FRAME_KEY);
  }

  private unRegisterDragEvent(): void {
    log.showInfo('unRegisterDragEvent');
    this.mPcStatusBarDragMgr.unRegisterDragEvent(this.mDragEventCallback, Constants.PC_TRAY_DROP_FRAME_KEY);
  }

  private onStartSqueezedEvent(translatePosition: number[][]): void {
    this.currentTranslatePosition = translatePosition[1];
    log.showInfo(`onStartSqueezedEvent startTranslatePosition: ${translatePosition[1][0]}, ${translatePosition[1][1]}`);
    this.animateToMove(translatePosition[1][0], translatePosition[1][1]);
    this.mShowWhiteBox = true;
  }

  animateToMove(x: number, y: number): void {
    animateTo({
      duration: 200,
      curve: this.translateCurve,
      onFinish: () => {
        if (!PcStatusBarDragMgr.getInstance().getShowDropFrameIcon()) {
          this.iconImage = undefined;
        } else {
          this.iconImage = this.mPcStatusBarDragMgr.getSnapshot();
        }
      }
    }, () => {
      // 基于当前位置做动画
      this.mWhiteBoxX = x;
      this.mWhiteBoxY = y;
    });
  }

  private initDragEventCallback(): void {
    this.mDragEventCallback = {
      onItemDragStartEvent: (): void => {
        if (!PcStatusBarDragMgr.getInstance().getShowDropFrameIcon()) {
          this.iconImage = undefined;
        } else {
          this.iconImage = this.mPcStatusBarDragMgr.getSnapshot();
        }
        this.startTranslatePosition = this.mPcStatusBarDragMgr.getStartDragPos();
        this.mWhiteBoxX = this.startTranslatePosition?.[0];
        this.mWhiteBoxY = this.startTranslatePosition?.[1];
        this.mShowWhiteBox = true;
        log.showInfo(`onItemDragStartEvent startTranslatePosition: ${this.mWhiteBoxX}, ${this.mWhiteBoxY}`);
      },
      onItemDropStartEvent: (): void => {
        log.showInfo('onItemDropStartEvent');
      },
      onItemDropEndEvent: (): void => {
        log.showInfo('onItemDropEndEvent');
        this.mShowWhiteBox = false;
        this.startTranslatePosition = [];
        this.currentTranslatePosition = [];
      },
      onStartSqueezedEvent: (translatePosition: number[][]): void => {
        log.showInfo('onStartSqueezedEvent');
        if (!PcStatusBarDragMgr.getInstance().getShowDropFrameIcon()) {
          this.iconImage = undefined;
        } else {
          this.iconImage = this.mPcStatusBarDragMgr.getSnapshot();
        }
        this.onStartSqueezedEvent(translatePosition);
      },
      onCancelSqueezedEvent: (hasAnimation: boolean): void => {
        this.animateToMove(this.startTranslatePosition[0], this.startTranslatePosition[1]);
        log.showInfo(`onCancelSqueezedEvent x: ${this.startTranslatePosition[0]}, Y:${this.startTranslatePosition[1]}`);
      }
    }
  }

  build() {
    Column() {
      if (this.iconImage) {
        Image(this.iconImage).draggable(false)
          .width(28)
          .height(28)
          .enabled(false)
          .opacity(0.5)
      }
    }
    .justifyContent(FlexAlign.Center)
    .id(TAG)
    .width(40)
    .height(40)
    .position({ start: LengthMetrics.vp(this.mWhiteBoxX), top: LengthMetrics.vp(this.mWhiteBoxY) })
    .opacity(this.mShowWhiteBox ? 1 : 0)
    .onDrop((event: DragEvent, extraParams?: string) => {
      log.showInfo('onDrop');
      if (event) {
        event.useCustomDropAnimation = true;
        event.setResult(DragResult.DRAG_FAILED);
      }
      this.mPcStatusBarDragMgr.onDropInTrayFrame(extraParams);
    })
  }
}
