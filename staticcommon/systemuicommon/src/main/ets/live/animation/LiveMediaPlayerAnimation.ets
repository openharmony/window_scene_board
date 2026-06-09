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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimationBase } from '../../animation/AnimationBase';
import { LiveNotification } from '../model/LiveNotification';
import { curves } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveMediaPlayerAnimation');

/**
 * 播控的实况胶囊与卡片的动画
 */
export class LiveMediaPlayerAnimation extends AnimationBase {
  /**
   * 播控图标切换动效位移
   */
  private readonly ICON_OFFSET_X: number = 16;
  private readonly ICON_OFFSET_Y: number = 22;

  /**
   * 播控图标切换动效位移曲线
   */
  private readonly ICON_OFFSET_CURVE: curves.ICurve = curves.interpolatingSpring(0, 1, 600, 50);

  /**
   * 播控图标切换动效位移延时
   */
  private readonly ICON_OFFSET_DELAY: number = 150;

  /**
   * 播控图标切换动效缩放
   */
  private readonly ICON_SCALE: number = 0.8;

  /**
   * 播控图标切换动效缩放曲线
   */
  private readonly ICON_SCALE_CURVE: curves.ICurve = curves.interpolatingSpring(0, 1, 300, 30);

  /**
   * 播控图标切换动效缩放延时
   */
  private readonly ICON_SCALE_DELAY: number = 350;

  /**
   * 播控图标切换遮罩透明度变化时间
   */
  private readonly ICON_MASK_OPACITY_TIME: number = 50;

  private vmInjector: ILiveVmInjector;

  constructor(vmInjector: ILiveVmInjector) {
    super(AnimationBase.NAMES.LIVE_MEDIA_PLAYER_ANIMATION, true);
    this.vmInjector = vmInjector;
  }

  public async updateIconAnimation(live: LiveNotification): Promise<void> {
    // 清理上一次动画数据
    this.clearAnimations();

    const liveMediaPlayerVm = this.vmInjector.getLiveMediaPlayerVm(live);
    // 设置图标切换动效初始值
    liveMediaPlayerVm.maskOpacity = 0;
    liveMediaPlayerVm.oldMediaIconOpacity = 1;
    liveMediaPlayerVm.oldMediaIconScale = { x: 1, y: 1 };
    liveMediaPlayerVm.oldMediaIconOffsetX = 0;
    liveMediaPlayerVm.oldMediaIconOffsetY = 0;
    liveMediaPlayerVm.mediaIconScale = { x: this.ICON_SCALE, y: this.ICON_SCALE };
    liveMediaPlayerVm.mediaIconOffsetX = RTLUtil.isRTL() ? -this.ICON_OFFSET_X : this.ICON_OFFSET_X;
    liveMediaPlayerVm.mediaIconOffsetY = this.ICON_OFFSET_Y;
    // 设置动画过程中的值
    this.addAnimation([
      {
        curve: Curve.Sharp,
        duration: this.ICON_MASK_OPACITY_TIME,
        event: () => {
          liveMediaPlayerVm.maskOpacity = 0.3;
        }
      },
      {
        curve: this.ICON_SCALE_CURVE,
        event: () => {
          liveMediaPlayerVm.oldMediaIconScale = { x: this.ICON_SCALE, y: this.ICON_SCALE };
        }
      },
      {
        curve: this.ICON_OFFSET_CURVE,
        delay: this.ICON_OFFSET_DELAY,
        event: () => {
          liveMediaPlayerVm.oldMediaIconOffsetX = RTLUtil.isRTL() ? -this.ICON_OFFSET_X : this.ICON_OFFSET_X;
          liveMediaPlayerVm.oldMediaIconOffsetY = -this.ICON_OFFSET_Y;
          liveMediaPlayerVm.mediaIconOffsetX = 0;
          liveMediaPlayerVm.mediaIconOffsetY = 0;
        }
      },
      {
        curve: Curve.Sharp,
        delay: this.ICON_SCALE_DELAY,
        duration: this.ICON_MASK_OPACITY_TIME,
        event: () => {
          liveMediaPlayerVm.maskOpacity = 0;
        }
      },
      {
        curve: this.ICON_SCALE_CURVE,
        delay: this.ICON_SCALE_DELAY,
        event: () => {
          liveMediaPlayerVm.mediaIconScale = { x: 1, y: 1 };
        }
      }
    ])
    log.showInfo(`start update media icon animation`);
    await this.startAnimation(`UpdateMediaPlayerIcon`);
  }
}