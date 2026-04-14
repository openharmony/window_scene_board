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

import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from '../../aigcServiceAbility/IdlService/Log';
import { FormUtils } from '../../utils/FormUtils';

const TAG: string = 'OuterDesktopEditPage';
export const OUTER_DESKTOP_EDIT = 'outerDesktopEdit';
@Component
export struct OuterDesktopEditPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  private tempFormCardIdList: string = '';
  private count: number = 0;

  aboutToAppear() {
    Log.info(TAG, `aboutToAppear`);
    this.count++;
    AppStorage.setOrCreate('isSinglePocketInnerEditMode', true);
  }

  aboutToDisappear() {
    Log.info(TAG, `aboutToDisappear`);
    this.count--;
    AppStorage.setOrCreate('isSinglePocketInnerEditMode', false);
    if (this.count === 0) {
      FormUtils.deleteFormByIdBatch(this.tempFormCardIdList);
      this.tempFormCardIdList = '';
    }
  }

  build() {
    NavDestination() {
      Column() {
        this.uiExtensionComponent();
      }
      .width('100%')
      .height('100%')
    }
    .onBackPressed(() => {
      this.pageInfos.pop(true);
      return true;
    })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .hideTitleBar(true)
  }

  @Builder
  uiExtensionComponent() {
    UIExtensionComponent({
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'OuterDeskTopEditAbilityPhone',
      parameters: {
        'ability.want.params.uiExtensionType': 'sys/commonUI',
        'nav': 'outerDesktopEditUiPage',
        'desktopParam': AppStorage.get<Object>('outerDesktopParam')
      }
    })
      .id('outerDesktopEditUiPage')
      .size({ width: '100%', height: '100%' })
      .onRemoteReady((proxy) => {
        Log.info(TAG, `Pull up UIExtensionAbility success`);
      })
      .onError((error: BusinessError) => {
        Log.info(TAG, `code ${error.code} message ${error.message}`);
      })
      .onRelease(() => {
        this.pageInfos.pop();
        Log.info(TAG, 'onRelease onBack success');
      })
      .onReceive((data) => {
        Log.info(TAG, 'onReceive back OuterDesktopEditPage');
        if (data && data['tempFormCardIdList'] && data['tempFormCardIdList'] instanceof String &&
          (typeof data['tempFormCardIdList']) === 'string') {
          this.tempFormCardIdList = this.tempFormCardIdList.concat(data['tempFormCardIdList'] as string);
        }
        if (data && data['intent'] === 'return_to_previous_page') {
          this.pageInfos.pop();
        }
        Log.info(TAG, `onReceive ${JSON.stringify(data)}`);
      })
  }
}