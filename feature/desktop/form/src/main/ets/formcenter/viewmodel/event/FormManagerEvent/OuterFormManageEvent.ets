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

import { AttributeUpdater } from '@kit.ArkUI';
import { CardItemInfo, CommonConstants, NoIconAppInfo, NoIconAppModel } from '@ohos/launchercommon';
import { IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { FormManagerEventInterface } from '../../../interfaces/FormManagerEventInterface';
import {
  OuterManagerTitleWrapper,
  OutFormManagerTitle } from '../../../view/atomicview/FormManagerTitle/OuterFormManagerTitle';
import { FormManagerEvent } from './FormManagerEvent';
import { SwiperLayoutEventInterface } from '../../../interfaces/SwiperLayoutEventInterface';
import { SwiperLayoutEvent } from '../swiperlayoutevent/SwiperLayoutEvent';
import { FormCenterFormCommonUtil } from '../FormCenterFormCommonUtil';
import { ManagerTitleBuilderInterface } from '../../../interfaces/FormManagerSheetTitleInterface';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';

const TAG = 'OuterFormManagerEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class OuterFormManagerEvent extends FormManagerEvent implements FormManagerEventInterface {
  private defaultTitleName: string = '';
  private textUpdater: AttributeUpdater<TextAttribute, TextInterface> = new AttributeUpdater();

  getTitleBuilder(): ManagerTitleBuilderInterface {
    return new OuterManagerTitleWrapper();
  }

  getSwiperLayoutEvent(): SwiperLayoutEventInterface {
    this.mViewData.addFormButtonWidth = FormStyleConstants.OUTER_ADD_FORM_BUTTON_WIDTH;
    let event: SwiperLayoutEvent = new SwiperLayoutEvent(this.mSwiperLayoutData, this.mViewData, this.mAppInfo);
    event.initSwiperIndexChangeCallBack((formItem: CardItemInfo) => {
      FormCenterFormCommonUtil.getResourceName(this.defaultTitleName, formItem.displayNameId,
        'displayName', formItem).then((value: string) => {
          log.showWarn(`update name: ${value}`);
          this.textUpdater.updateConstructorParams(value);
      });
    });
    return event;
  }

  getFormNameUpdater(): AttributeUpdater<TextAttribute, TextInterface> {
    this.updateDefaultName();
    return this.textUpdater;
  }


  private updateDefaultName(): void {
    let iconResourceManager: IconResourceManager = IconResourceManager.getInstance();
    this.defaultTitleName = this.mAppInfo.appName as string;
    if (NoIconAppModel.getInstance().checkIfBundleIsNoIconApp(this.mAppInfo.bundleName as string)) {
      let iconInfo: NoIconAppInfo = NoIconAppModel.getInstance().updateNoIconAppInfo(this.mAppInfo.bundleName);
      this.defaultTitleName = this.mAppInfo.bundleName === CommonConstants.SCENEBOARD_BUNDLE ?
        ResourceManager.getInstance().getStringByName('lock_screen') : iconInfo.label;
    } else {
      if (CheckEmptyUtils.checkStrIsEmpty(this.defaultTitleName)) {
        this.defaultTitleName = iconResourceManager.getCachedIconNameSync(this.mAppInfo.bundleName,
          this.mAppInfo.moduleName, this.mAppInfo.abilityName);
        log.showWarn(`update appName ${this.defaultTitleName}`);
      }
    }
  }
}