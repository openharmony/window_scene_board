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
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { INotificationMoreVm, NotificationBaseVm, ResourceVm } from '@ohos/systemuicommon/newIndex';
import { MoreNotificationCollapsedAnimation } from '../animation/MoreNotificationCollapsedAnimation';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { NtfAnimationConsts } from '../common/NtfAnimationConsts';
import { UpdateType } from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationListVm';

const TAG = 'NotificationMoreVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const APP_ICON_SIZE = 32;
const NTF_DELAY = 50;
const TRAN_EFFECT_SIZE = 4;

/**
 * 更多通知管理
 *
 * @since 2024-11-23
 */
@ObservedV2
export class NotificationMoreVm extends NotificationBaseVm implements INotificationMoreVm {
  private static readonly NTF_EXTRA_BRIEF_COUNT_THRESHOLD = 30;
  private static readonly HAS_SHADOW: ShadowOptions = {
    radius: 2,
    color: $r('app.color.ntf_extra_brief_shadow_color'),
    offsetX: 2,
    offsetY: 0
  };
  private static readonly NO_SHADOW: ShadowOptions = {
    radius: 0,
    color: $r('app.color.ntf_extra_brief_shadow_color'),
    offsetX: 0,
    offsetY: 0
  };

  public listVm = this.vmInjector.getListVm();
  public scrollVm = this.vmInjector.getListScrollerVm();
  /**
   * 是否在折叠状态下重新创建卡片
   */
  @Trace public isCreatedExtraBriefWhenCollapsed: boolean = false;

  @Trace public textTranEffect: TransitionEffect = TransitionEffect.IDENTITY;

  @Trace public iconTranEffects: TransitionEffect[] = [];
  /**
   * 是否在展开或折叠过程中
   */
  @Trace public isExtraNtfsCollapseStatusChanging: boolean = false;
  /**
   * 是否被屏幕朗读主动聚焦
   */
  public isAccessibilityFocused: boolean = false;

  @Computed get moreList(): NotificationBase[] {
   return this.listVm ? this.listVm.moreNtfList.concat() : [];
  }

  @Computed get moreNtfAppList(): NotificationBase[] {
    const moreNtfAppList: NotificationBase[] = [];
    this.moreList.forEach((value) => {
      if (moreNtfAppList.findIndex((ntf) => ntf.hashCode === value.hashCode) < 0) {
        moreNtfAppList.push(value);
      }
    });
    return moreNtfAppList;
  }

  @Computed get briefContent(): string {
    const appNameList: string[] = [];
    let appCount = 0;
    for (const ntf of this.moreNtfAppList) {
      appNameList.push(ntf.appLabel ?? '');
      appCount++;
      if (appCount >= NotificationMoreVm.NTF_EXTRA_BRIEF_COUNT_THRESHOLD) {
        log.showInfo('app name count is reach threshold.')
        break;
      }
    }
    return appNameList.join('、');
  }

  public getIconWidth(): string {
    let length = Math.min(3, this.listVm?.moreNtfList.length ?? 0);
    if (length > 0) {
      return (length > 1 ? ((length - 1) * APP_ICON_SIZE / 2 + APP_ICON_SIZE + 1) : APP_ICON_SIZE) + 'vp';
    }
    return '0vp';
  }

  public getAppIconShadow(ntf: NotificationBase): ShadowOptions {
    const isShadow = (this.getNtfIndex(ntf) ?? 0) < (Math.min(3, this.moreList.length ?? 0) - 1);
    return isShadow ? NotificationMoreVm.HAS_SHADOW : NotificationMoreVm.NO_SHADOW;
  }

  public getZIndex(ntf: NotificationBase): number {
    const index = this.getNtfIndex(ntf);
    let length = this.listVm?.moreNtfList.length;
    if (length && length > 0) {
      return length - index;
    }
    return 0;
  }

  public getStartMargin(ntf: NotificationBase): string {
    const index = this.getNtfIndex(ntf);
    const mark = RTLUtil.isRTL() ? -1 : 1
    return mark * (APP_ICON_SIZE * index / 2 + (index === 0 ? 0 : 1)) + 'vp';
  }

  public getNtfIndex(ntf: NotificationBase): number {
    const index = this.moreList.findIndex((item) => item.groupKey === ntf.groupKey);
    return Math.max(0, index);
  }

  /**
   * 获取更多通知图标动效
   *
   * @param index 图标索引值
   * @returns 图标动效
   */
  public getIconAnimation(ntf: NotificationBase): TransitionEffect {
    const index = this.getNtfIndex(ntf);
    return this.iconTranEffects[index];
  }

  public getTextTranEffectWhenCollapsed(): void {
    const appearEffect = this.isCreatedExtraBriefWhenCollapsed ? TransitionEffect.IDENTITY :
    TransitionEffect.translate({ x: ResourceVm.instance.getXDirectionValue(-20) })
      .animation({
        delay: this.moreList ? this.getFirstExtraNtfDelayTime() : 0,
        curve: NtfAnimationConsts.EXTRA_NTF_EXPAND_CURVE,
      })
    this.textTranEffect = TransitionEffect.asymmetric(appearEffect, this.getTextTranEffect());
  }

  public getIconTranEffectWhenCollapsed(): void {
    const iconTranEffects: TransitionEffect[] = [];
    iconTranEffects[0] = TransitionEffect.IDENTITY;
    iconTranEffects[1] = this.getOtherIconTranEffect(1);
    iconTranEffects[2] = this.getOtherIconTranEffect(2);
    this.iconTranEffects = iconTranEffects;
  }

  private getOtherIconTranEffect(index: number): TransitionEffect {
    const appearEffect = this.isCreatedExtraBriefWhenCollapsed ? TransitionEffect.IDENTITY :
    MoreNotificationCollapsedAnimation.getOtherIconTranEffect(index)
    return TransitionEffect.asymmetric(appearEffect,
      MoreNotificationCollapsedAnimation.getIconDisappearTranEffect(index));
  }

  private getIconTranEffect(): TransitionEffect[] {
    const iconTranEffects: TransitionEffect[] = [];
    for (let i = 0; i < TRAN_EFFECT_SIZE; i++) {
      iconTranEffects[i] = MoreNotificationCollapsedAnimation.getIconDisappearTranEffect(i);
    }
    return iconTranEffects;
  }

  private getTextTranEffect(): TransitionEffect {
    return TransitionEffect.OPACITY.animation({ duration: 116 });
  }

  /**
   * 获取第一条更多通知的动效延迟时间
   *
   * @returns 动效延迟时间
   */
  public getFirstExtraNtfDelayTime(): number {
    // 第一条更多通知的动效延迟时间与第二条更多通知的延迟时间相同，且extraHeader会占一个位置，因此要减去2
    let delayNtfNum = (this.scrollVm?.endIndex ?? 0) - (this.listVm?.mainNtfList?.length ?? 0) - 2;
    if (this.listVm?.isShowBottomTransCard) {
      // 如果存在透明卡片，则需要除去透明卡片
      delayNtfNum -= 1;
    }
    return Math.max(delayNtfNum, 0) * NTF_DELAY;
  }

  @Monitor('isExtraNtfsCollapseStatusChanging')
  changeTransitionEffect() {
    if (!this.isExtraNtfsCollapseStatusChanging) {
      this.textTranEffect = this.getTextTranEffect();
      this.iconTranEffects = this.getIconTranEffect();
      const listVm = this.vmInjector.getListVm();
      listVm?.moreNtfList.forEach((ntf) => {
        //  更多通知折叠动效做完后，把只有一条子通知的组通知变为单通知
        this.vmInjector.getNormalGroupVm(ntf)?.collapseGroup();
        if (ntf.isNormalGroup() && ntf.children.length === 1) {
          listVm?.releaseGroup(ntf);
        }
      });
      listVm?.updateNtf({ updateType: UpdateType.COLLAPSE });
    }
  }

  public getMoreBriefBgColor(): ResourceColor | undefined {
    return this.vmInjector.getColorVm().ntfCardBgColor;
  }
}