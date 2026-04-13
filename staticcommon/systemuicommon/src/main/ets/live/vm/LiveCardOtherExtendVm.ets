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

import { LiveItemBaseVm } from './LiveBaseVm'
import { ILiveCardOtherExtendVm } from '../interface/ILiveCardOtherExtendVm';
import { TextEmojiHelper } from '../../utils/TextEmojiHelper';
import { LiveCardOtherModel } from '../model/LiveCardOtherModel';
import { LiveCardType, LiveExtensionType } from '../model/LiveCommonModel';
import { LiveStyle } from '../constants/LiveStyle';
import { AnimationBase } from '../../animation/AnimationBase';
import { ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { BannerPanelType } from '../../banner/common/info/BannerState';
import { NotificationType } from '../../constants/NotificationType';
import { BrightnessOptionUtils } from '../../template/newStyle/BrightnessOptionUtils';
import { LiveCardFloatingWantAgentParams } from '../interface/ILiveCardFloatingVm';
import { sharedData } from '../../model/SendableData';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { WantAgentUtil } from '../../utils/WantAgentUtil';

@ObservedV2
export class LiveCardOtherExtendVm extends LiveItemBaseVm implements ILiveCardOtherExtendVm {
  protected TAG: string = 'LiveCardOtherExtendVm';

  @Computed
  get extendWidth(): number | string | undefined {
    return this.live.card?.isNavigationCard() ? 56 : 44;
  }
  @Computed
  get extendHeight(): number | string | undefined {
    return this.live.card?.isNavigationCard() ? 36 : 44;
  }

  get normalTextWidth(): number | string | undefined {
    return 30;
  }

  get normalTextHeight(): number | string | undefined {
    return 28;
  }

  get normalTextMaxFont(): Length | undefined {
    return '14vp';
  }

  get normalTextMinFont(): Length | undefined {
    return '10vp';
  }

  get capsuleButtonHeight(): number | string | undefined {
    return 24;
  }

  get capsuleButtonWidth(): Length | undefined {
    return 44;
  }

  get capsuleButtonMaxWidth(): Length | undefined {
    return 70;
  }

  get capsuleButtonTextHeight(): number | string | undefined {
    return 20;
  }

  get capsuleButtonTopMargin(): number | undefined {
    return 2;
  }

  get capsuleButtonLeftMargin(): number | undefined {
    return 8;
  }

  get buttonLength(): number | string | undefined {
    return 40;
  }

  get textColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
  }

  @Trace private imageOpacity: number = 1;

  @Computed get card(): LiveCardOtherModel {
    return this.live.card as LiveCardOtherModel
  }

  @Computed get buttonBgColor(): ResourceColor | string | undefined {
    if (!this.live?.isAtomicServiceFromPush &&
      this.card?.cardType === LiveCardType.PICK_UP &&
      this.live?.capsule?.backgroundColor) {
      return this.live?.capsule?.backgroundColor;
    }
    return $r('app.color.ntf_brightness_bg_color');
  }

  @Computed
  get weatherButtonBgColor(): ResourceColor | string | undefined {
    return $r('app.color.ntf_brightness_bg_color');
  }

  @Computed get fontFgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().extendFontFgBrightness;
  }

  @Computed get buttonBgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().extendButtonBgBrightness;
  }

  @Computed get isRenderGroup(): boolean {
    return TextEmojiHelper.isEmoji(this.card?.extensionText ?? '') ? false : true;
  }

  @Computed get weatherButtonBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().extendButtonBgBrightness;
  }

  @Computed get opacity(): number | undefined {
    const card = this.live.card as LiveCardOtherModel;
    if (card.extensionType === LiveExtensionType.PICTURE || card.extensionType === LiveExtensionType.ICON) {
      return this.imageOpacity;
    }

    return undefined;
  }

  @Computed get buttonTextOpacity(): number | undefined {
    return undefined;
  }

  @Computed get tapGesture(): TapGestureHandler | undefined {
    if (!this.card.extensionWantAgent && !this.live.isCollaNotification) {
      return undefined;
    }
    return new TapGestureHandler().onAction(this.triggerExtendWant);
  }

  public async startImageAnim(delay: number = 0): Promise<void> {
    const card = this.live.card as LiveCardOtherModel;
    if (card.extensionType !== LiveExtensionType.PICTURE && card.extensionType !== LiveExtensionType.ICON) {
      return;
    }

    const animation = new AnimationBase(AnimationBase.NAMES.OTHER_CARD_EXTEND_ANIMATION);
    animation.setInitialState(() => {
      this.imageOpacity = 0;
    });
    await animation.executeAnimation([
      {
        duration: 200,
        curve: Curve.Friction,
        delay: delay,
        event: () => {
          this.imageOpacity = 1;
        }
      }
    ]);
  }

  protected triggerExtendWant = async (): Promise<void> => {
    const menuVm = this.vmInjector.getCardMenuVm(this.live);
    const itemVm = this.vmInjector.getCardListItemVm(this.live);
    if (menuVm && itemVm.containerOffsetX) {
      menuVm.reset('self');
      return;
    }

    if (!this.card.extensionWantAgent && !this.live.isCollaNotification) {
      return;
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.SUB_AREA,
      scene: SystemUIUseScene.LIVE,
    });
    this.log.showInfo(`triggerExtendWant for ${this.live.hashCode}`);

    const floatingVm = this.vmInjector.getCardFloatingVm(this.live);
    const params: LiveCardFloatingWantAgentParams = { wantAgent: this.card.extensionWantAgent };
    if (await floatingVm.canOpenFloating(params)) {
      sharedData.isExecuting = true;
      floatingVm.startFloatingForClick(params);
      floatingVm.runCardHideAnimation(() => {
        this.vmInjector.getCardListVm().listOpacity = 0;
      }).then(() => {
        this.log.showInfo(`Start floating app ${this.live.key} end`);
        sharedData.isExecuting = false;
        this.vmInjector.getSwitchVm().hidePanel();
        this.vmInjector.getCapsuleListVm().toggleCapsuleList();
      });
      return;
    }

    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      this.triggerHeadsUpExtendWant();
      return;
    }

    /**
     * 端侧辅助区点击类型有拉起应用与发送公共事件
     * 云侧辅助区点击类型有0-拉起应用,1-拉起其他页面，3-删除实况，5-拉起拨号页面
     * 该类型字段被打包放入agentInfo中无法获取
     */
    const isStartApp = await this.vmInjector.getStarterVm().startCardWantAgent({
      wantAgent: this.card.extensionWantAgent,
      cardVm: this.vmInjector.getCardListItemVm(this.live),
      onStartApp: () => {
        bannerMgr.releasePanelLiveList();
      },
      operationInfo: {
        operationType: LiveStyle.DISTRIBUTE_OPERATION_BUTTON_JUMP,
        buttonIndex: 0,
      }
    });
    LiveHiSysEvent.reportClickExtendEvent(this.live, NotificationType.TYPE_PHONE_LIVELIST);
    if (!isStartApp.start) {
      return;
    }
    LiveHiSysEvent.reportLiveClickAppEvent(this.live, 5);
    this.vmInjector.getSwitchVm().hidePanel();
    this.vmInjector.getCapsuleListVm().toggleCapsuleList();
  }

  protected triggerHeadsUpExtendWant = async (): Promise<void> => {
    await this.vmInjector.getStarterVm().startCardWantAgent({
      wantAgent: this.card.extensionWantAgent,
      cardVm: this.vmInjector.getCardListItemVm(this.live),
      onStartApp: () => {
        bannerMgr.releaseLiveHeadsUp();
        bannerMgr.requestPanelCapsuleList();
      },
      operationInfo: {
        operationType: LiveStyle.DISTRIBUTE_OPERATION_BUTTON_JUMP,
        buttonIndex: 0,
      }
    });

    LiveHiSysEvent.reportClickExtendEvent(this.live, NotificationType.TYPE_PHONE_LIVELIST);
    LiveHiSysEvent.reportLiveClickAppEvent(this.live, 3);
    this.vmInjector.getSwitchVm().hidePanel();
    this.vmInjector.getLiveHeadsUpVm().hide(this.live);
  }
}