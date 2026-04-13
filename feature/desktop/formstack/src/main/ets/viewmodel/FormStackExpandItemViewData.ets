/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import type image from '@ohos.multimedia.image';
import { CardItemInfo, layoutLockUtil } from '@ohos/launchercommon';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { ResourceManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackExpandEventInterface } from '../common/FormStackExpandEventInterface';
import { FormStackExpandModel } from '../common/FormStackExpandModel';
import { FormStackManager } from '../common/FormStackManager';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackExpandItem } from './FormStackExpandItem';

const TAG: string = 'FormStackExpandItemViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Observed
export class FormStackExpandItemViewData {
  public mItemInfo?: FormStackExpandItem;
  public mEventInterface?: FormStackExpandEventInterface;
  public mVisible: boolean = false;
  public mFormMargin: number = 0;
  public mDeleteImageMoveLongestDistance: number = 0;
  public mDeleteImageShowHeight: number = 0;
  public mDeleteImgTranslateX: number = 0;
  public mDeleteImgMoveDistanceThreshold: number = 0;
  public mDragSnapshot?: image.PixelMap = undefined;
  public mDeleteImageShow: boolean = false;
  public mCardInfo: CardItemInfo = new CardItemInfo();

  public initData(itemInfo: FormStackExpandItem, eventInterface: FormStackExpandEventInterface): void {
    if (!itemInfo || !eventInterface) {
      log.showError('init data failed, itemInfo or eventInterface is invalid!');
      return;
    }

    this.mItemInfo = itemInfo;
    this.mEventInterface = eventInterface;
    this.initCardInfo();
    this.initFormOffsetData();
    this.mVisible = true;
    // 预置布局页的堆叠不显示删除按钮
    let position: number[] = FormStackManager.getInstance().getFormStackPosition();
    this.mDeleteImageShow = !(position.length > 0 && layoutLockUtil.isLockedPage(position[0], 'show delete image',
      true));

    let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    this.mFormMargin = config.mIsExpandCenter ? (config.mDisplayWidth - config.mFormWidth) / 2 :
      config.mDisplayWidth - config.mFormWidth - config.mFormStackOffsetX;
    if (RTLUtil.isRTL()) {
      this.mFormMargin = config.mIsExpandCenter ? (config.mDisplayWidth - config.mFormWidth) / 2 :
        config.mFormStackOffsetX;
    }
    if (this.mFormMargin < FormStackConstants.DELETE_IMAGE_MARGIN_LEFT_MIN) {
      this.mDeleteImageMoveLongestDistance = (config.mFormWidth *
        FormStackConstants.SWIPE_DELETE_IMAGE_PERCENT_OF_FORM + this.mFormMargin) / 2;
    } else {
      this.mDeleteImageMoveLongestDistance = config.mIsExpandCenter ?
        (this.mFormMargin - FormStackConstants.DELETE_IMAGE_WIDTH) / 2 :
        config.mFormWidth * FormStackConstants.DELETE_IMAGE_MOVE_SNOW_PERCENT;
    }

    this.mDeleteImgMoveDistanceThreshold = config.mFormShowWidth * FormStackConstants.FORM_MOVE_DELETE_PERCENT -
      this.mDeleteImageMoveLongestDistance;
    this.updateDelImgTranslateX();
  }

  public resetData(): void {
    this.mFormMargin = 0;
    this.mDeleteImageMoveLongestDistance = 0;
    this.mVisible = false;
    this.mDeleteImgMoveDistanceThreshold = 0;

    this.mItemInfo = undefined;
    this.mEventInterface = undefined;
    FormStackUtil.releasePixelMap(this.mDragSnapshot);
    this.mDragSnapshot = undefined;
  }

  public initFormOffsetData(): void {
    if (!this.mItemInfo || !this.mEventInterface?.isTopItemOfFormStack) {
      log.showError('init form offset info failed, item info or isTopItemOfFormStack interface is invalid!');
      return;
    }

    const formShowHeight: number = FormStackExpandConfig.getInstance().mFormShowHeight;
    if (this.mEventInterface.isTopItemOfFormStack(this.mItemInfo.idStr)) {
      this.mItemInfo.delImgShowHeight = formShowHeight * (1 - Math.abs(this.mItemInfo.rotateX) /
        FormStackConstants.RIGHT_ANGLE_ROTATION);
    } else {
      this.mItemInfo.delImgShowHeight = formShowHeight * FormStackExpandConfig.getInstance().mMaxShowRatio *
        (1 - Math.abs(this.mItemInfo.rotateX) / FormStackConstants.RIGHT_ANGLE_ROTATION);
    }
  }

  public updateDelImgTranslateX(): void {
    if (!this.mItemInfo) {
      log.showError('itemInfo is invalid, init data failed!');
      return;
    }

    let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    if (config.mFormWidth <= 0) {
      log.showError('formWidth is Invalid');
      return;
    }

    let moveRate: number = Math.abs(this.mDeleteImageMoveLongestDistance / (config.mFormWidth *
      FormStackConstants.DELETE_IMAGE_MOVE_SNOW_PERCENT));
    let isMinMargin: boolean = this.mFormMargin < FormStackConstants.DELETE_IMAGE_MARGIN_LEFT_MIN;
    let marginLeft: number = 0;
    const deleteImgWidth = FormStackConstants.DELETE_IMAGE_WIDTH;
    if (!config.mIsExpandCenter) {
      marginLeft = isMinMargin ? config.mDisplayWidth - deleteImgWidth / 2 :
        config.mFormStackOffsetX + config.mFormWidth * 1.2 +
        FormStackConstants.DELETE_BUTTON_DISTANCE_FORM_STACK_RIGHT_MARGIN;
    } else {
      marginLeft = isMinMargin ? config.mDisplayWidth - deleteImgWidth / 2 : config.mDisplayWidth - deleteImgWidth;
    }
    if (RTLUtil.isRTL()) {
      if (!config.mIsExpandCenter) {
        marginLeft = isMinMargin ? -deleteImgWidth / 2 : config.mFormStackOffsetX - config.mFormWidth * 0.2 -
          FormStackConstants.DELETE_BUTTON_DISTANCE_FORM_STACK_RIGHT_MARGIN - deleteImgWidth;
      } else {
        marginLeft = isMinMargin ? -deleteImgWidth / 2 : 0;
      }
    }
    // 垃圾桶位置不能超过屏幕宽度 - deleteImgWidth - 15(垃圾桶与屏幕的右边距)
    this.mDeleteImgTranslateX = Math.min(marginLeft + this.mItemInfo.translateX * moveRate,
      config.mDisplayWidth - deleteImgWidth - FormStackConstants.DELETE_BUTTON_DISTANCE_FORM_SCREEN_RIGHT_MARGIN);
    if (RTLUtil.isRTL()) {
      this.mDeleteImgTranslateX = Math.max(this.mDeleteImgTranslateX,
        FormStackConstants.DELETE_BUTTON_DISTANCE_FORM_SCREEN_RIGHT_MARGIN);
    }
  }

  private initCardInfo(): void {
    let expandModel: FormStackExpandModel = this.mEventInterface?.getFormStackExpandModel?.() as FormStackExpandModel;
    if (!expandModel) {
      log.showError('init img data failed, expandModel is invalid!');
      return;
    }
    this.mCardInfo = expandModel.getCardInfo(this.mItemInfo?.idStr as string) as CardItemInfo;

    if (!CheckEmptyUtils.checkStrIsEmpty(this.mCardInfo.appName)) {
      return;
    }
    ResourceManager.getInstance()
      .getAppNameWithCache(this.mCardInfo.appLabelId, this.mCardInfo.bundleName, this.mCardInfo.moduleName, '',
        (name: string): void => {
          if (CheckEmptyUtils.checkStrIsEmpty(name)) {
            const appBundleName: string = ResourceManager.getInstance().getBundleAppName(this.mCardInfo.bundleName);
            log.showInfo(`initCardInfo appBundleName: ${appBundleName}`);
            this.mCardInfo.appName = appBundleName;
          } else {
            this.mCardInfo.appName = name;
          }
        });
  }
}