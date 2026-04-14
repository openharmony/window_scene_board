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
import { EnvVm } from '../../../../vm/EnvVm';
import { ILiveCardListVm } from '../../../interface/ILiveCardListVm';
import { LiveCardListVm } from '../../../vm/LiveCardListVm';
import { BannerManagerAdapter } from '../../../../adapter/BannerManagerAdapter';
import { DefaultPanelZIndex } from '../../../../base/common/info/DefaultPanelZIndex';
import { LiveStyle } from '../../../constants/LiveStyle';
import { CardScaleUtil } from '../../../../utils/CardScaleUtil';
import { InnerEventUtil } from '../../../../utils/InnerEventUtil';
import { EnableBackGestureEvent } from '../../../../immersivekeyguardcommon/event/ImmersiveEvent';
import { uiEffect } from '@kit.ArkGraphics2D';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';

const MIN_VALID_DISTANCE: number = 4;

@ObservedV2
export class PocketLiveCardListVm extends LiveCardListVm implements ILiveCardListVm {
  protected readonly TAG = 'PocketLiveCardListVm';

  private envVm = EnvVm.instance;
  private isPanelHide: boolean = false;

  public init(): void {
    super.init();
    this.changeBannerZIndex();
  }

  @Computed public get isNeedHeaderBlur(): boolean {
    return false;
  }

  @Computed public get space(): number {
    return LiveStyle.CARD_LIST_SPACE;
  }

  @Monitor('envVm.isScreenLock', 'deviceInfoVm.isOuterHome')
  changeBannerZIndex(changes?: IMonitor): void {
    return;
  }

  public async resetList(): Promise<void> {
    await super.resetList();
  }

  public onPanelShow(): void {
    this.isPanelHide = false;
  }

  public onPanelHide(): void {
    this.isPanelHide = true;
    this.isShowHeaderBlur = false;
  }

  public onListWillScroll(offsetTop: number, scrollState: ScrollState): void {
    const scrollY = -this.scroller.currentOffset().yOffset;
    this.isShowHeaderBlur = scrollY < -4;
    super.onListWillScroll(offsetTop, scrollState);
  }

  public getHeaderBlurFilter(): Filter | undefined {
    try {
      const filter = uiEffect.createFilter();
      return filter.radiusGradientBlur(40, {
        fractionStops: [[1, 0], [0, 1]],
        direction: GradientDirection.Bottom
      });
    } catch (e) {
      this.log.showError(`getHeaderBlurFilter failed: ${e}`);
      return undefined;
    }
  }
}