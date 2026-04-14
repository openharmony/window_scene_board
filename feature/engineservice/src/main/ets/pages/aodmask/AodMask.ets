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

import lazy image from '@ohos.multimedia.image';
import lazy fs from '@ohos.file.fs';
import lazy { AnimationConstants } from './AnimationConstants';
import lazy { AodMaskDataManager } from './AodMaskDataManager';
import { PathReloadStrategy, RootPathChangeListener } from '../../utils/PathReloadStrategy';
import { FileUtil } from '../../utils/FileUtil';
import { Log } from '../../utils/Log';

const TAG: string = 'AodMask';

const OFFSET_ARR_SIZE: number = 2;

const ROTATE_TIMEOUT: number = 500;

// aod界面壁纸放大为1.05倍，导致所有偏移量计算全部异常，需要对遮罩层进行缩放比例矫正，保证遮罩层实际大小是全屏1:1的
const SCALE_CORRECTION: number = 1 / 1.05;

@Reusable
@Component
export struct AodMask {
  @State @Watch('loadAodMask')
  public maskSrc: string = '';

  @State
  private maskPixelMap?: image.PixelMap = undefined;

  @StorageLink('aodMaskOffset')
  private maskOffset: number[] = [0, 0];

  @StorageLink('aodMaskOpacity')
  private maskOpacity: number = 0;

  @StorageLink('aodMaskScale')
  private maskScale: number = AnimationConstants.AOD_INVISIBLE_SCALE;

  private aodDataMgr: AodMaskDataManager = AodMaskDataManager.getInstance();

  private rootPathListener: RootPathChangeListener = {
    onRootPathChange: async () => {
      this.maskSrc =
        `/data/themes/${FileUtil.getThemePathId().toLowerCase()}/system/aod/base/resources/decoration.png`;
    },
  };

  private loadAodMask(): void {
    try {
      if (!fs.accessSync(this.maskSrc)) {
        Log.warn(TAG, `AOD mask resource not found.`);
        return;
      }
    } catch (err) {
      Log.error(TAG, `Error on accessing AOD mask file ${err?.code}`);
    }

    const imageSrc: image.ImageSource = image.createImageSource(this.maskSrc);
    this.maskPixelMap?.release();
    Log.info(TAG, `Updating AOD mask resource.`);
    this.maskPixelMap = imageSrc.createPixelMapSync();

    imageSrc.release();
  }

  public aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.maskSrc =
      `/data/themes/${FileUtil.getThemePathId().toLowerCase()}/system/aod/base/resources/decoration.png`;

    this.loadAodMask();

    // Vertical index at 1
    if (this.maskOffset.length === OFFSET_ARR_SIZE) {
      this.maskOffset[1] = this.aodDataMgr.getExitTarget();
    }
    PathReloadStrategy.getInstance().addUpdateRootPathListener(this.rootPathListener);
  }

  public aboutToDisappear(): void {
    Log.info(TAG, 'On disappear');

    this.maskPixelMap?.release();
    PathReloadStrategy.getInstance().removeUpdateRootPathListener(this.rootPathListener);
  }

  public aboutToRecycle(): void {
    Log.info(TAG, 'On recycle');
    this.maskPixelMap?.release();
  }

  public aboutToReuse(): void {
    Log.info(TAG, 'On reuse');
    this.loadAodMask();
  }

  public build(): void {
    AodMaskUIGroup({
      maskPixelMap: this.maskPixelMap,
    })
      .height('100%')
      .width('100%')
      .renderFit(RenderFit.RESIZE_COVER)
      .opacity(this.maskOpacity)
      .scale({
        x: this.maskScale,
        y: this.maskScale,
      })
      .offset({
        x: this.maskOffset[0] + 'px',
        y: this.maskOffset[1] + 'px',
      });
  }
}

@Component
struct AodMaskUIGroup {
  @ObjectLink
  public maskPixelMap?: image.PixelMap;

  @StorageLink('topPadding')
  private topPadding: number = 0;

  @StorageLink('maskEdgeLength')
  private maskEdgeLength: number = 0;

  build() {
    Stack() {
      Column() {
        Blank()
          .height(this.topPadding)
          .backgroundColor(Color.Black)
        Row() {
          Blank()
            .backgroundColor(Color.Black)
          Image(this.maskPixelMap)
            .width(this.maskEdgeLength)
            .height(this.maskEdgeLength)
            .objectFit(ImageFit.Cover)
          Blank()
            .backgroundColor(Color.Black)
        }
        .width('100%')
        Blank()
          .backgroundColor(Color.Black)
      }
      .renderGroup(true)
      .height('100%')
    }
    .height('100%')
    .width('100%')
    .scale({
      x: SCALE_CORRECTION,
      y: SCALE_CORRECTION,
    })
  }
}