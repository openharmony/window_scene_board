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
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { ILiveCardMediaPlayerVm } from '../interface/ILiveCardMediaPlayerVm';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveCardSystemModel } from '../model/LiveCardSystemModel';
import { LiveNotification } from '../model/LiveNotification';

export interface LiveCardMediaPlayerBuilderParam {
  notifyId: string;
  groupKey: string;
  isNotificationFromDeviceChange: boolean;
  isScreenLock: boolean;
  scene: SystemUIUseScene;
  onItemClick?: () => void;
}

/**
 * 播控卡片组件
 */
@ComponentV2
export struct LiveCardMediaPlayerView {
  @Consumer() liveVmInjector: ILiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;
  private static builder?: WrappedBuilder<[LiveCardMediaPlayerBuilderParam]>;

  public static setBuilder(builder: WrappedBuilder<[LiveCardMediaPlayerBuilderParam]>): void {
    LiveCardMediaPlayerView.builder = builder;
  }

  @Computed get cardVm(): ILiveCardMediaPlayerVm | undefined {
    return this.liveVmInjector.getCardMediaPlayerVm?.(this.live);
  }

  build() {
    LiveCardMediaPlayerView.builder?.builder({
      notifyId: this.live.hashCode,
      isNotificationFromDeviceChange: (this.live.card as LiveCardSystemModel)?.title === '',
      isScreenLock: this.cardVm?.isScreenLock ?? false,
      groupKey: this.live.groupKey,
      scene: this.liveVmInjector.scene,
      onItemClick: this.cardVm?.onIconClick
    })
  }
}