/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  FormStackItemBuildInterface,
  FormStackItemBuildParam,
  FormStackItemViewData,
  formStackItemViewManager
} from '@ohos/launchercommon/Index';
import { CardNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import {
  CardItemInfo,
  FormCommonUtil,
  GridLayoutItemInfo,
  StyleConstants,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormStackEventCb } from '../common/FormStackEventCb';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackAnimateItem } from '../viewmodel/FormStackAnimateItem';
import { FormStackItemEvent } from '../viewmodel/FormStackItemEvent';

const TAG: string = 'FormStackItemView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormStackItemView {
  private mEventCallback?: FormStackEventCb;
  private mCardItem: CardItemInfo = new CardItemInfo();
  private mFormStackItemEvent: FormStackItemEvent = new FormStackItemEvent();
  private mFormStackId: string = '';
  private mFixedOffsetY: number = 0;
  private mFormBorderRadius: number = 0;
  private mBuildInterface: FormStackItemBuildInterface | undefined;

  @ObjectLink mAnimateItem: FormStackAnimateItem;
  @Prop @Watch('onWidthChange') mFormStackItemWidth: number;
  @Prop @Watch('onHeightChange') mFormStackItemHeight: number;
  private mIsOuterDesktop: boolean = false;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @Prop mFormStackTopCardId: string = '';

  private onWidthChange(): void {
    this.mAnimateItem.mWidth = this.mFormStackItemWidth;
  }

  private onHeightChange(): void {
    this.mAnimateItem.mHeight = this.mFormStackItemHeight;
  }

  private buildLog(): boolean {
    log.showDebug('build form: cardId=%{public}d, opacity=%{public}d, scaleX=%{public}d, scaleY=%{public}d,' +
      'zIndex=%{public}d, clickable=%{public}s, bundleName=%{public}s, rotate=%{public}d',
      Number(this.mCardItem.cardId), this.mAnimateItem.mOpacity, this.mAnimateItem.mScaleX,
      this.mAnimateItem.mScaleY, this.mAnimateItem.zIndex,
      this.mAnimateItem.mClickable, this.mAnimateItem.bundleName, this.mAnimateItem.mRotateAngle);
    return true;
  }
  aboutToAppear() {
    this.mAnimateItem.mWidth = this.mFormStackItemWidth;
    this.mAnimateItem.mHeight = this.mFormStackItemHeight;
    this.mFormStackItemEvent.initData({
      formStackId: this.mFormStackId,
      borderRadius: this.mFormBorderRadius,
      cardItem: this.mCardItem,
      eventCallback: this.mEventCallback
    }, this.mAnimateItem);
    this.mBuildInterface =
      formStackItemViewManager.getFormBuilderInterface(this.mCardItem as object as GridLayoutItemInfo);

    log.showWarn('build form stack item, cardId: %{public}s, cardName: %{public}s, bundleName: %{public}s, ' +
      'abilityName: %{public}s, moduleName: %{public}s, cardDimension: %{public}d, isTransparent: %{public}s, ' +
      'formConfigAbility: %{public}s, page: %{public}d, column: %{public}d, row: %{public}d, appLabelId: %{public}d, ' +
      'extend1: %{public}s',
      this.mCardItem.cardId, this.mCardItem.cardName, this.mCardItem.bundleName, this.mCardItem.abilityName,
      this.mCardItem.moduleName, this.mCardItem.cardDimension, this.mCardItem.isTransparent,
      this.mCardItem.formConfigAbility, this.mCardItem.page, this.mCardItem.column, this.mCardItem.row,
      this.mCardItem.appLabelId, this.mCardItem.extend1);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear cardId: ${this.mCardItem.cardId}`);
    this.mFormStackItemEvent.resetData();
  }

  build() {
    Stack() {
      if (this.buildLog()) {}
      this.mBuildInterface?.buildView()?.builder({
        mConfigData: {
          mLayout: this.mCardItem as object as GridLayoutItemInfo,
          mFixedOffsetY: this.mFixedOffsetY,
          mIsOuterDesktop: this.mIsOuterDesktop,
          cardDimension: this.mCardItem.cardDimension,
          mShadowStyle: {
            radius: StyleConstants.FORM_SHADOW_RADIUS,
            color: StyleConstants.FORM_SHADOW_COLOR,
            offsetY: StyleConstants.FORM_SHADOW_OFFSETY
          } as ShadowOptions,
          mCompId: FormStackUtil.getFormComponentId(this.mCardItem),
        },
        mEventCb: this.mFormStackItemEvent,
        mViewData: this.mAnimateItem as FormStackItemViewData,
      })
    }
    .enabled(this.mAnimateItem.mClickable)
    .width(this.mFormStackItemWidth)
    .height(this.mFormStackItemHeight)
    .translate({ x: 0, y: this.mAnimateItem.mTranslateY })
    .offset({ x: 0, y: this.mAnimateItem.mIsOffsetY ? this.mFixedOffsetY : 0 })
    .scale({ x: this.mAnimateItem.mScaleX, y: this.mAnimateItem.mScaleY, centerX: '50%', centerY: '0%' })
    .opacity(this.mAnimateItem.mOpacity)
    .zIndex(this.mAnimateItem.zIndex)
    .hitTestBehavior(HitTestMode.Transparent)
    .accessibilityLevel(this.mCardItem.cardId === this.mFormStackTopCardId ? 'no' : 'no-hide-descendants')
  }
}
