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

import AiSuggestionAnimHelperTest from './ets/default/animation/AiSuggestionAnimHelper.test';
import { ExposeEventRecorderTest } from './ets/default/donate/ExposeEventRecorder.test';
import { UpdateAiSuggestionFormsTest } from './ets/default/service/impl/UpdateAiSuggestionForms.test';
import { ResetAiSuggestionFormsTest } from './ets/default/service/impl/ResetAiSuggestionForms.test';
import { AbilityFormUtilTest } from './ets/default/utils/AbilityFormUtil.test';
import { QuerySpecifiedScreenInfosTest } from './ets/default/service/impl/QuerySpecifiedScreenInfos.test';
import { QueryExposeEventLogsTest } from './ets/default/service/impl/QueryExposeEventLogs.test';
 import { AiSuggestionServiceTest } from './ets/default/service/AiSuggestionService.test';
import { AiSuggestionFormManagerTest } from './ets/default/manager/AiSuggestionFormManager.test';
import { AiSuggestionResourceManagerTest } from './ets/default/manager/AiSuggestionResourceManager.test';
import { RemoveAbilityFormTest } from './ets/default/service/impl/RemoveAbilityForm.test';
import { JsonHelperTest } from './ets/default/utils/JsonHelper.test';
import HandleDialogClickTest from './ets/default/service/impl/HandleDialogClick.test';
import { LauncherCardInfoTest } from './ets/default/bean/LauncherCardInfo.test';
import { DataPreferenceTest } from './ets/default/utils/DataPreference.test';
import { LauncherRecItemTest } from './ets/default/bean/LauncherRecItem.test';
import { ExtraDataTest } from './ets/default/bean/ExtraData.test';
import { LauncherExposeEventLogsTest } from './ets/default/bean/LauncherExposeEventLogs.test';
import { QueryFormDistributionTest } from './ets/default/service/impl/QueryFormDistribution.test';
import { CommandConsumerTest } from './ets/default/command/CommandConsumer.test';
import { LauncherFormDistributionTest } from './ets/default/bean/LauncherFormDistribution.test';
import { AiSuggestionLayoutChangeHelperTest } from './ets/default/manager/AiSuggestionLayoutChangeHelper.test';
import { AiSuggestionLayoutStyleFactoryTest } from './ets/default/config/AiSuggestionLayoutStyleFactory.test';
import { AiSuggestionMidLayoutStyleTest } from './ets/default/config/AiSuggestionMidLayoutStyle.test';
import { AiSuggestionLargeLayoutStyleTest } from './ets/default/config/AiSuggestionLargeLayoutStyle.test';
import { AiSuggestionMinLayoutStyleTest } from './ets/default/config/AiSuggestionMinLayoutStyle.test';
import { AiSuggestionDragEventProcessorTest } from './ets/default/event/AiSuggestionDragEventProcessor.test';
import { OperateFormStackHelperTest } from './ets/default/manager/OperateFormStackHelper.test';
import { ServiceValidatorTest } from './ets/default/utils/ServiceValidator.test';
import CommandListTest from './ets/default/command/CommandList.test';
import AddFormToFormStackCommandTest from './ets/default/command/imp/AddFormToFormStackCommand.test';
import CreateFormStackCommandTest from './ets/default/command/imp/CreateFormStackCommand.test';
import UpdateFormsCommandTest from './ets/default/command/imp/UpdateFormsCommand.test';
import SwitchCardToTopCommandTest from './ets/default/command/imp/SwitchCardToTopCommand.test';
import DeleteCardFromFormStackCommandTest from './ets/default/command/imp/DeleteCardFromFormStackCommand.test';
import DataConverterTest from './ets/default/utils/DataConverter.test';
import AiSuggestionEventReporterTest from './ets/default/donate/AiSuggestionEventReporter.test';
import AiSuggestionLayoutStyleTest from './ets/default/config/AiSuggestionLayoutStyle.test';
import AiSuggestionMenuBuilderTest from './ets/test/menu/AiSuggestionMenuBuilder.test';
import AiSuggestionViewModelTest from './ets/test/model/AiSuggestionViewModel.test';
import DeviceUtilTest from './ets/test/utils/DeviceUtil.test';
import LanguageUtilTest from './ets/test/utils/LanguageUtil.test';

function AiSuggestionAnimationTest() {
  AiSuggestionAnimHelperTest();
}

function AiSuggestionBeanTest() {
  ExtraDataTest();
  LauncherCardInfoTest();
  LauncherExposeEventLogsTest();
  LauncherFormDistributionTest();
  LauncherRecItemTest();
}

function AiSuggestionCommandTest() {
  CommandConsumerTest();
  CommandListTest();
  AddFormToFormStackCommandTest();
  CreateFormStackCommandTest();
  DeleteCardFromFormStackCommandTest();
  SwitchCardToTopCommandTest();
  UpdateFormsCommandTest();
}

function AiSuggestionConfigTest() {
  AiSuggestionLayoutStyleFactoryTest();
  AiSuggestionMidLayoutStyleTest();
  AiSuggestionLargeLayoutStyleTest();
  AiSuggestionMinLayoutStyleTest();
  AiSuggestionLayoutStyleTest();
}

function AiSuggestionDonateTest() {
  ExposeEventRecorderTest();
  AiSuggestionEventReporterTest();
}

function AiSuggestionManagerTest() {
  AiSuggestionFormManagerTest();
  AiSuggestionResourceManagerTest();
  OperateFormStackHelperTest();
}

function AiSuggestionServiceImplTest() {
  AiSuggestionServiceTest();
  HandleDialogClickTest();
  QueryExposeEventLogsTest();
  QueryFormDistributionTest();
  QuerySpecifiedScreenInfosTest();
  RemoveAbilityFormTest();
  ResetAiSuggestionFormsTest();
  UpdateAiSuggestionFormsTest();
}

function AiSuggestionUtilsTest() {
  AbilityFormUtilTest();
  DataPreferenceTest();
  JsonHelperTest();
  DataConverterTest();
  ServiceValidatorTest();
  DeviceUtilTest();
  LanguageUtilTest();
}

function AiSuggestionEventTest() {
  AiSuggestionDragEventProcessorTest();
}

/**
 * 单元测试
 *
 * @since 2023-10-17
 */
export default function testsuite() {
  AiSuggestionAnimationTest();
  AiSuggestionBeanTest();
  AiSuggestionCommandTest();
  AiSuggestionConfigTest();
  AiSuggestionDonateTest();
  AiSuggestionManagerTest();
  AiSuggestionEventTest();

  AiSuggestionServiceImplTest();
  AiSuggestionUtilsTest();
  AiSuggestionLayoutChangeHelperTest();

  AiSuggestionMenuBuilderTest();
  AiSuggestionViewModelTest();
}