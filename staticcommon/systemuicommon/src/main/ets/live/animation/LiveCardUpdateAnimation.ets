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
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { curves } from '@kit.ArkUI';
import { LiveNotification } from '../model/LiveNotification';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ILiveCardListItemVm } from '../interface/ILiveCardListItemVm';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { ArkUIAdapter, ViewName } from '../../utils/ArkUIAdapter';

const TAG = 'LiveCardUpdateAnimation';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const OFFSET_CURVE = curves.interpolatingSpring(0, 1, 150, 17);
const SCALE_CURVE = curves.interpolatingSpring(0, 1, 130, 18);
const CARD_OFFSET = 17;
const CARD_DELAY = 200;

/**
 * 实况卡片更新动效
 */
export class LiveCardUpdateAnimation extends AnimationBase {
  private vmInjector: ILiveVmInjector;

  constructor(vmInjector: ILiveVmInjector) {
    super(AnimationBase.NAMES.LIVE_CARD_UPDATE_ANIMATION, true);
    this.vmInjector = vmInjector;
  }

  /**
   * 展开卡片动画
   *
   * @param oldIndex
   * @returns
   */
  public async sort(oldIndex: number): Promise<void> {
    this.clearAnimations();
    const liveList = this.vmInjector.getCardListVm().liveList;
    const live = liveList[oldIndex];
    // 排序
    const newIndex = this.sortList(live, liveList);
    if (newIndex === oldIndex) {
      return;
    }

    // 设置初始状态
    const cardVm = this.vmInjector.getCardListItemVm(live);
    this.setCardInitialState(oldIndex, newIndex, liveList, cardVm);
    // 设置动效
    this.addTopCardAnimation(oldIndex, newIndex, liveList);
    this.addCardAnimation(cardVm);
    this.addBottomCardAnimation(oldIndex, liveList);
    await this.startAnimation();
  }

  protected afterAnimation(): void {
    this.vmInjector.getCardListVm().liveList.forEach((live) => {
      if (live) {
        const itemVm = this.vmInjector.getCardListItemVm(live);
        itemVm.zIndex = 1;
      }
    })
  }

  private sortList(live: LiveNotification, liveList: LiveNotification[]): number {
    liveList.sort();
    return liveList.findIndex((item) => item.hashCode === live.hashCode);
  }

  private setCardInitialState(oldIndex: number, newIndex: number, liveList: LiveNotification[],
    cardVm: ILiveCardListItemVm): void {
    let height = 0;
    const uiContext = ArkUIAdapter.getUiContextByViewName(ViewName.BANNER_VIEW);
    const cardRect = SystemUICommonUtil.getRect(cardVm.componentId, uiContext);
    for (let i = newIndex + 1; i <= oldIndex; i++) {
      if (liveList[i]) {
        const topCardVm = this.vmInjector.getCardListItemVm(liveList[i]);
        topCardVm.containerOffsetY = -(cardRect.height + LiveStyle.CARD_LIST_SPACE);
        topCardVm.zIndex = 0;
        height += LiveStyle.CARD_LIST_SPACE + SystemUICommonUtil.getRect(topCardVm.componentId, uiContext).height;
      }
    }
    cardVm.containerOffsetY = height;
  }

  private addTopCardAnimation(oldIndex: number, newIndex: number, liveList: LiveNotification[]): void {
    let animateParams: AnimateParams[] = [];
    for (let i = newIndex + 1; i <= oldIndex; i++) {
      if (liveList[i]) {
        const topCardVm = this.vmInjector.getCardListItemVm(liveList[i]);
        const delay = i * CARD_OFFSET;
        animateParams.push(
          {
            delay: delay,
            curve: OFFSET_CURVE,
            event: () => topCardVm.containerOffsetY = 0,
          },
          {
            curve: SCALE_CURVE,
            event: () => {
              topCardVm.containerScale = { x: 0.85, y: 0.85 };
              topCardVm.contentBlur = 15;
            }
          },
          {
            delay: CARD_DELAY,
            curve: SCALE_CURVE,
            event: () => {
              topCardVm.containerScale = { x: 1, y: 1 };
              topCardVm.contentBlur = 0;
            }
          },
        );
      }
    }
    this.addAnimation(animateParams);
  }

  private addCardAnimation(cardVm: ILiveCardListItemVm): void {
    let animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        curve: OFFSET_CURVE,
        event: () => {
          cardVm.containerOffsetY = 0;
          cardVm.contentBlur = 15;
        }
      },
      {
        delay: CARD_DELAY,
        curve: OFFSET_CURVE,
        event: () => {
          cardVm.contentBlur = 0;
        }
      },
    );
    this.addAnimation(animateParams);
  }

  private addBottomCardAnimation(oldIndex: number, liveList: LiveNotification[]): void {
    let animateParams: AnimateParams[] = [];
    for (let i = oldIndex + 1; i < liveList.length; i++) {
      if (liveList[i]) {
        const itemVm = this.vmInjector.getCardListItemVm(liveList[i]);
        const delay = (i - oldIndex) * CARD_OFFSET;
        animateParams.push(
          {
            delay: delay,
            curve: OFFSET_CURVE,
            event: () => itemVm.containerOffsetY = -15,
          },
          {
            delay: delay + 166,
            curve: OFFSET_CURVE,
            event: () => itemVm.containerOffsetY = 0,
          },
        );
      }
    }
    this.addAnimation(animateParams);
  }
}