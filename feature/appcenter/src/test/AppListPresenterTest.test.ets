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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { EventConstants} from '@ohos/frameworkwrapper';
import { AppListPresenter } from '../main/ets/default/common/presenter/AppListPresenter';
import { AppLayoutInfo } from '../main/ets/default/common/viewmodel/AppLayoutInfo';

export function AppListPresenterTest() {
  describe('AppListPresenterTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_AppListPresenterTest_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = AppListPresenter.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = AppListPresenter.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('test_AppListPresenterTest_regroupDataAppListChange', Level.LEVEL0, (): void => {
      let bundleName: string = 'com.ohos.appgallery';
      AppListPresenter.getInstance().regroupDataAppListChange([],EventConstants.EVENT_PACKAGE_CHANGED);
      expect().assertTrue();
    })

    it('test_AppListPresenterTest_getAppList', Level.LEVEL0, (): void => {
      AppListPresenter.getInstance().getAppList();
      expect().assertTrue();
    })

    it('test_AppListPresenterTest_getInstallingAppList', Level.LEVEL0, (): void => {
      AppListPresenter.getInstance().getAppList();
      expect().assertTrue();
    })

    it('test_AppListPresenterTest_searchAndFilterApps', Level.LEVEL0, (): void => {
      let bundleName: string = 'com.ohos.appgallery';
      let searchAppPageList: AppLayoutInfo[] = [];
      AppListPresenter.getInstance().searchAndFilterApps(bundleName,searchAppPageList);
      expect().assertTrue();
    })

    it('test_AppListPresenterTest_deleteAppCenterItem', Level.LEVEL0, (): void => {
      let bundleName: string = 'com.ohos.appgallery';
      AppListPresenter.getInstance().deleteAppCenterItem(bundleName);
      expect().assertTrue();
    })

  })
}