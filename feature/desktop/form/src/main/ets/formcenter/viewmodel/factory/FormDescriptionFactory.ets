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

import { CardItemInfo, CommonConstants } from '@ohos/launchercommon';
import { FormDescriptionEventInterface } from '../../interfaces/FormDescriptionEventInterface';
import { FormCenterViewModel } from '../FormCenterViewModel';
import { FormDescriptionVm } from '../data/FormDescriptionVm';
import { FormCenterFormCommonUtil } from '../event/FormCenterFormCommonUtil';

const SCAN_CARD_NAME: string = 'ServiceScan';

interface FormTypeParam {
  formItem: CardItemInfo;
}

export class TileFormDescriptionFactory {
  public static createFormItemEvent(param: FormTypeParam): FormDescriptionEventInterface {
    if (FormCenterViewModel.getInstance().isScreenLock) {
      return {
        updateFormDescriptionVm: async (vm: FormDescriptionVm, item: CardItemInfo) => {
          if (item.cardName === SCAN_CARD_NAME) {
            vm.mDisplayName = await FormCenterFormCommonUtil.getResourceName(item.appName as string,
              item.displayNameId, 'displayName', item);
            return;
          }
          vm.mDisplayName = item.appName as string;
        }
      };
    }

    if (param.formItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE) {
      return {
        updateFormDescriptionVm: async (vm: FormDescriptionVm, item: CardItemInfo) => {
          vm.mDisplayName = item.appName as string;
          vm.mDescription = item.description as string;
        }
      };
    }

    return {
      updateFormDescriptionVm: async (vm: FormDescriptionVm, item: CardItemInfo) => {
        vm.mDisplayName = item.appName as string;
        vm.mDescription = await FormCenterFormCommonUtil.getResourceName(item.appName as string,
          item.descriptionId, 'description', item);
      }
    };
  }
}