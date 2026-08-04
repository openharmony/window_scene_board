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

import FormEditViewDataTest from './ets/default/viewmodel/FormEditViewData.test'
import SearchComponentTest from './ets/default/view/SearchComponent.test'
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
import { FormStyleConfigTest } from './ets/default/common/FormStyleConfig.test';
import { AppFormWeightManagerTest } from './ets/default/manager/AppFormWeightManager.test';
import { FormUtilTest } from './ets/default/util/FormUtil.test';
import { GridRowManagerTest } from './ets/default/manager/GridRowManager.test';
import { AppInstallDataSourceTest } from './ets/default/datasource/AppInstallDataSource.test';
import { AppUpdateDataSourceTest } from './ets/default/datasource/AppUpdateDataSource.test';
import { BaseDataSourceTest } from './ets/default/datasource/BaseDataSource.test';
import { BigDataDataSourceTest } from './ets/default/datasource/BigDataDataSource.test';
import { BreakPointServiceTest } from './ets/default/service/BreakPointService.test';
import { CardsDataPoolTest } from './ets/default/datapool/CardsDataPool.test';
import { FormDetailLayoutConfigTest } from './ets/default/common/FormDetailLayoutConfig.test';
import { FormHiSysEventUtilTest } from './ets/default/util/FormHiSysEventUtil.test';
import { FormPreLoaderTest } from './ets/default/common/FormPreLoader.test';
import { FormViewModelTest } from './ets/default/viewmodel/FormViewModel.test';
import { HighFrequencyAppDataSourceTest } from './ets/default/datasource/HighFrequencyAppDataSource.test';
import { IncrementDataSourceTest } from './ets/default/datasource/IncrementDataSource.test';
import { DataSourceTest } from './ets/default/datasource/DataSource.test';
import { ServiceFormManagerTest } from './ets/default/manager/ServiceFormManager.test';
import { ServiceFormManagerBackupTest } from './ets/default/manager/ServiceFormManagerBackup.test';
import { RecommendCardsDataPoolTest } from './ets/default/datapool/RecommendCardsDataPool.test';
import { RecommendFormManagerTest } from './ets/default/manager/RecommendFormManager.test';
import { ServiceFormAppItemConfigTest } from './ets/default/common/ServiceFormAppItemConfig.test';
import { FormHostServiceTest } from './ets/default/service/FormHostService.test';
import { FormHostServiceBackupTest } from './ets/default/service/FormHostServiceBackup.test';
import { FormCenterAnimateTest } from './ets/default/viewmodel/FormCenterAnimate.test';
import { FormCenterViewModelTest } from './ets/default/viewmodel/FormCenterViewModel.test';
import { ScreenLockFormModelTest } from './ets/default/viewmodel/ScreenLockFormModel.test';
import { RecommendFormsViewEventTest } from './ets/default/viewmodel/RecommendFormsViewEvent.test';
import { FormCenterViewDataTest } from './ets/default/viewmodel/FormCenterViewData.test';
import { OpenFormCenterServiceTest } from './ets/default/service/OpenFormCenterService.test';
import StyleManagerTest from './ets/default/manager/StyleManager.test';
import { NegativeScreenFormEventTest } from './ets/formcentertest/manager/NegativeScreenFormEvent.test';
import { DesktopFormTest } from './ets/default/view/DeskTopForm.test';
import { ScreenLockFormTest } from './ets/formcentertest/view/ScreenLockForm.test';
import { FormEditViewTest } from './ets/default/view/FormEditView.test';
import { LiteGamesDataSourceTest } from './ets/default/datasource/LiteGamesDataSource.test';

export default function FormTestSuite() {
  FormUtilTest();
  GridRowManagerTest();
  FormStyleConfigTest();
  AppFormWeightManagerTest();
  AppInstallDataSourceTest();
  AppUpdateDataSourceTest();
  BaseDataSourceTest();
  BigDataDataSourceTest();
  BreakPointServiceTest();
  CardsDataPoolTest();
  FormDetailLayoutConfigTest();
  FormHiSysEventUtilTest();
  FormPreLoaderTest();
  FormViewModelTest();
  HighFrequencyAppDataSourceTest();
  IncrementDataSourceTest();
  DataSourceTest();
  ServiceFormManagerTest();
  ServiceFormManagerBackupTest();
  RecommendCardsDataPoolTest();
  RecommendFormManagerTest();
  ServiceFormAppItemConfigTest();
  FormHostServiceTest();
  FormHostServiceBackupTest();
  FormCenterAnimateTest();
  FormCenterViewModelTest();
  ScreenLockFormModelTest();
  RecommendFormsViewEventTest();
  FormCenterViewDataTest();
  SearchComponentTest();
  DesktopFormTest();
  OpenFormCenterServiceTest();
  StyleManagerTest();
  FormEditViewDataTest();
  NegativeScreenFormEventTest();
  ScreenLockFormTest();
  FormEditViewTest();
  LiteGamesDataSourceTest();
}