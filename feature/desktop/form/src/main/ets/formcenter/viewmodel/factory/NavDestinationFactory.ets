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

import { CommonConstants } from '@ohos/launchercommon'
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NavDestinationBuilderInterface } from '../../interfaces/NavDestinationBuilderInterface'
import FormStyleConstants from '../../../default/common/constants/FormStyleConstants';
import { NavConfig, NavDestinationLayout, NavItemType } from '../../viewstyles/manager/NavConfig';
import { NavTileLayoutWrapper } from '../../view/layout/NavTileLayout';
import { FormTileScrollLayoutWrapper } from '../../../default/view/waterfall/FormTileScrollLayout';
import { NavSwiperLayoutWrapper } from '../../view/layout/NavSwiperLayout';
import FormConstants from '../../../default/common/constants/FormConstants';
import { NavNoResultLayoutWrapper } from '../../view/layout/NavNoResultLayout';

const TAG = 'NavDestinationFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export interface NavDestinationParam {
  name: string,
}

export class NavDestinationFactory {
  public static createNavLayout(param: NavDestinationParam): NavDestinationBuilderInterface {
    log.showWarn(`get layout, param name : ${param.name}`);

    if (param.name === FormConstants.NO_SEARCH_RESULT) {
      return new NavNoResultLayoutWrapper();
    }

    if (param.name === FormStyleConstants.FORM_CENTER_DEFAULT_ITEM) {
      return NavDestinationFactory.getInterfaceFormMap(NavItemType.SUGGESTION);
    }

    return NavDestinationFactory.getInterfaceFormMap(NavItemType.NORMAL_APP);
  }

  private static getInterfaceFormMap(type: NavItemType): NavDestinationBuilderInterface {
    if (NavConfig.getInstance().typeMap.get(type) === NavDestinationLayout.GRID) {
      log.showWarn(`NavDestinationFactory getInterfaceFormMap type: ${type}, grid`);
      return new FormTileScrollLayoutWrapper();
    }
    if (NavConfig.getInstance().typeMap.get(type) === NavDestinationLayout.SWIPER) {
      log.showWarn(`NavDestinationFactory getInterfaceFormMap type: ${type}, swiper`);
      return new NavSwiperLayoutWrapper();
    }
    log.showWarn(`NavDestinationFactory getInterfaceFormMap type: ${type}, tile`);
    return new NavTileLayoutWrapper();
  }
}