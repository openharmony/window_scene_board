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

import { LiveItemBaseVm } from './LiveBaseVm';
import { ILiveCardListItemVm } from '../interface/ILiveCardListItemVm';
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { LiveCardAnimation } from '../animation/LiveCardAnimation';
import { LiveStyle } from '../constants/LiveStyle';
import { ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { BannerVm } from '../../vm/BannerVm';
import { SceneSessionAdapter } from '../../adapter/SceneSessionAdapter';
import { LiveNotification } from '../model/LiveNotification';
import { LiveCardFloatingWantAgentParams } from '../interface/ILiveCardFloatingVm';
import { sharedData } from '../../model/SendableData';

const TAG = 'LiveCardListItemVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardListItemVm extends LiveItemBaseVm implements ILiveCardListItemVm {
  public readonly componentId: string = this.vmInjector.getId(`${TAG}_${this.live.hashCode}`);

  @Trace public containerSize: SizeOptions = { width: '100%', height: 'auto' };
  @Trace public contentSize?: SizeOptions;
  @Trace public contentAlign: Alignment = Alignment.End;
  @Trace public contentScale?: ScaleOptions;
  @Trace public contentOpacity: number = 1;
  @Trace public contentBlur: number = 0;
  @Trace public containerOffsetX: number = 0;
  @Trace public containerOffsetY: number = 0;
  @Trace public containerOpacity: number = 1;
  @Trace public containerScale?: ScaleOptions;
  @Trace public containerBorderRadius: number = LiveStyle.CARD_RADIUS;
  @Trace public cardGradientOpacity: number = 1;
  @Trace public cardBackOpacity: number = 1;
  @Trace public zIndex: number = 1;
  @Trace public cardShadow?: ShadowStyle = ShadowStyle.OUTER_DEFAULT_MD;
  @Trace public contentBorderRadius: number = LiveStyle.CARD_RADIUS;
  @Computed public get marginBottom(): number {
    return LiveStyle.CARD_LIST_SPACE;
  }
  @Computed public get cardWidth(): number {
    return BannerVm.instance.cardListWidth;
  }
  @Computed public get gesture(): GestureGroupHandler {
    return new GestureGroupHandler({
      mode: GestureMode.Exclusive,
      gestures: [new TapGestureHandler({ count: 1 }).onAction(() => this.onClick())]
    });
  };

  private touchStartX: number = 0;
  private touchStartY: number = 0;
  private inClickAnim: boolean = false;

  @Computed
  public get transition(): TransitionEffect {
    return this.vmInjector.getCardListVm().listOpacity === 1 ? LiveStyle.LIVE_CARD_TRANSITION :
    TransitionEffect.asymmetric(TransitionEffect.IDENTITY, TransitionEffect.IDENTITY);
  }

  @Computed
  public get cardGradientColor(): Array<[ResourceColor, number]> {
    if (!this.live.card.isSmallCard()) {
      const gradientColor = this.live.capsule?.backgroundColor ?? LiveStyle.CAPSULE_CONTENT_COLOR as string;
      return [[this.convertColorToRgba(gradientColor, 0.25), 0], ['rgba(0, 0, 0, 0.25)', 1]];
    }
    return [['rgba(0, 0, 0, 0)', 0], ['rgba(0, 0, 0, 0)', 1]];
  }

  protected animation = new AnimationBase(AnimationBase.NAMES.LIVE_CARD_LIST_ITEM_ANIMATION, true);

  public async updateSwipeOffset(offsetLeft: number, animation: boolean): Promise<void> {
    if (this.containerOffsetX === offsetLeft) {
      return;
    }
    log.showWarn(`updateSwipeOffset ${this.live.hashCode} from ${this.containerOffsetX} to ${offsetLeft}` +
      `, animation: ${animation}`);
    const menuVm = this.vmInjector.getCardMenuVm(this.live);
    menuVm.resetMenuWithAnim = false;
    if (animation) {
      menuVm.menuOpacityWithAnim = menuVm.menuOpacity;
      menuVm.resetMenuWithAnim = offsetLeft === 0;
      let cmds: AnimateParams[] = [{
        curve: AnimationBase.CURVES.SWIPE_RELEASE_CURVE,
        event: () => {
          this.containerOffsetX = offsetLeft;
        }
      }];
      if (!offsetLeft && menuVm.menuOpacity > 0) {
        // 收回菜单时对按钮做opacity动效
        cmds.push({
          curve: Curve.Linear,
          duration: 100,
          event: () => {
            menuVm.menuOpacityWithAnim = 0;
          }
        })
      }
      await this.animation.executeAnimation(cmds, `UpdateSwipeOffset:${this.live.hashCode}`);
    } else {
      this.containerOffsetX = offsetLeft;
    }
  }

  public async doRemoveAnimation(): Promise<void> {
    log.showInfo(`Do remove animation for: ${this.live.hashCode}`);
    const cardWidth = BannerVm.instance.cardListWidth;
    await this.animation.executeAnimation([
      {
        duration: 300,
        curve: Curve.Friction,
        event: () => {
          this.containerOffsetX = -cardWidth;
        }
      },
      {
        delay: 100,
        duration: 200,
        curve: Curve.Sharp,
        event: () => {
          this.containerOpacity = 0;
        }
      }
    ], `RemoveAnimation:${this.live.hashCode}`);
  }

  public onTouchEvent = (event: TouchEvent): void => {
    const cardAnimation = new LiveCardAnimation(this.vmInjector);
    if (event.type === TouchType.Down) {
      cardAnimation.touch(true, this.live);
      this.touchStartX = event.changedTouches[0].windowX;
      this.touchStartY = event.changedTouches[0].windowY;
      this.vmInjector.getCardMenuVm(this.live).reset('exceptSelf');
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel ||
      event.type === TouchType.Move &&
        (Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 4 ||
          Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 4)) {
      cardAnimation.touch(false, this.live);
    }
  };

  public async onClick(): Promise<void> {
    if (this.inClickAnim) {
      log.showInfo(`live ${this.live.hashCode} is started click, not need do again, return;`)
      return;
    }
    const menuVm = this.vmInjector.getCardMenuVm(this.live);
    const wantId: number = Reflect.get(this.live.wantAgent ?? {}, 'innerKey');
    log.showWarn(`Click content for ${this.live.hashCode}, containerOffsetX: ${this.containerOffsetX}, want: ${wantId}`);
    if (menuVm && this.containerOffsetX) {
      menuVm.reset('self');
      return;
    }
    this.inClickAnim = true;
    await this.startWantAgent();
    this.inClickAnim = false;
  }

  public async startWantAgent(): Promise<void> {
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.NTF_MAIN,
      scene: SystemUIUseScene.LIVE,
    });
    if (await this.tryOpenFloating(this.live)) {
      return;
    }
    const isStartApp = await this.vmInjector.getStarterVm().startCardWantAgent({
      cardVm: this,
      wantAgent: this.live.wantAgent,
      wantAgentInfo: this.live.wantAgentInfo,
      onStartApp: () => {
        this.vmInjector.getSwitchVm().isCollapsing = true;
        bannerMgr.releasePanelLiveList();
      }
    });
    if (isStartApp) {
      LiveHiSysEvent.reportLiveClickAppEvent(this.live, 5, await SceneSessionAdapter.getIsMidScene());
    }
    if (!isStartApp.start) {
      return;
    }
    this.vmInjector.getSwitchVm().hidePanel();
    this.vmInjector.getCapsuleListVm().toggleCapsuleList();
  };

  protected async tryOpenFloating(live: LiveNotification): Promise<boolean> {
    const floatingVm = this.vmInjector.getCardFloatingVm(live);
    const params: LiveCardFloatingWantAgentParams = { wantAgent: live.wantAgent, wantAgentInfo: live.wantAgentInfo };
    if (await floatingVm.canOpenFloating(params)) {
      sharedData.isExecuting = true;
      floatingVm.startFloatingForClick(params);
      floatingVm.runCardHideAnimation(() => {
        this.vmInjector.getCardListVm().listOpacity = 0;
      }).then(() => {
        log.showInfo(`Start floating app ${live.key} end`);
        sharedData.isExecuting = false;
        this.vmInjector.getSwitchVm().hidePanel();
        this.vmInjector.getCapsuleListVm().toggleCapsuleList();
      });
      LiveHiSysEvent.reportLiveClickAppEvent(live, 5);
      return true;
    }
    return false;
  }
}