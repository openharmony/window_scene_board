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

import { describe, it, expect } from '@ohos/hypium';
import { CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { AiSuggestionMenuBuilder } from '../../../../../../main/ets/default/menu/AiSuggestionMenuBuilder';

/**
 * AiSuggestionMenuBuilder测试
 *
 * @since 2025-06-11
 */
export default function AiSuggestionMenuBuilderTest() {
  describe('buildChildServiceMenu_testSuite', () => {
    it('atc_should_return_desktop_menus_when_containerType_is_CONTAINER_DESKTOP', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = CommonConstants.CONTAINER_DESKTOP;
      let childService: LauncherRecItem = new LauncherRecItem();
      let formDialog: CustomDialogController = new CustomDialogController({
        builder: 'builder',
        cancel: () => {
        },
      });
      const result: ESObject =
        aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService, formDialog);
      expect(result).assertDeepEquals([]);
    });

    it('atc_should_return_formStack_menus_when_containerType_is_TYPE_FORM_STACK', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = CommonConstants.TYPE_FORM_STACK;
      let childService: LauncherRecItem = new LauncherRecItem();
      const result: ESObject = aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService);
      expect(result).assertDeepEquals([]);
    });

    it('atc_should_return_empty_array_when_containerType_is_unknown', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = 999;
      let childService: LauncherRecItem = new LauncherRecItem();
      const result: ESObject = aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService);
      expect(result).assertDeepEquals([]);
    });
  });

  describe('buildChildServiceMenu_testSuite', () => {
    it('atc_should_return_desktop_menus_when_containerType_is_CONTAINER_DESKTOP', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = CommonConstants.CONTAINER_DESKTOP;
      let childService: LauncherRecItem = new LauncherRecItem();
      let formDialog: CustomDialogController = new CustomDialogController({
        builder: 'builder',
        cancel: () => {
        },
      });
      const result: ESObject = aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService, formDialog);
      expect(result).assertDeepEquals([]);
    });

    it('atc_should_return_formStack_menus_when_containerType_is_TYPE_FORM_STACK', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = CommonConstants.TYPE_FORM_STACK;
      let childService: LauncherRecItem = new LauncherRecItem();
      const result: ESObject = aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService);
      expect(result).assertDeepEquals([]);
    });

    it('atc_should_return_empty_array_when_containerType_is_unknown', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = 999;
      let childService: LauncherRecItem = new LauncherRecItem();
      const result: ESObject = aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService);
      expect(result).assertDeepEquals([]);
    });
  });

  describe('buildChildServiceMenu_testSuite', () => {
    it('atc_should_return_desktop_menus_when_containerType_is_CONTAINER_DESKTOP', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = CommonConstants.CONTAINER_DESKTOP;
      let childService: LauncherRecItem = new LauncherRecItem();
      let formDialog: CustomDialogController = new CustomDialogController({
        builder: 'builder',
        cancel: () => {
        },
      });
      const result: ESObject = aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService, formDialog);
      expect(result).assertDeepEquals([]);
    });

    it('atc_should_return_formStack_menus_when_containerType_is_TYPE_FORM_STACK', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = CommonConstants.TYPE_FORM_STACK;
      let childService: LauncherRecItem = new LauncherRecItem();
      const result: ESObject = aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService);
      expect(result).assertDeepEquals([]);
    });

    it('atc_should_return_empty_array_when_containerType_is_unknown', 0, () => {
      let aisuggestionmenubuilder: AiSuggestionMenuBuilder = new AiSuggestionMenuBuilder();
      let parentForm: GridLayoutItemInfo = new GridLayoutItemInfo();
      let containerType: number = 999;
      let childService: LauncherRecItem = new LauncherRecItem();
      const result: ESObject = aisuggestionmenubuilder.buildChildServiceMenu(parentForm, containerType, childService);
      expect(result).assertDeepEquals([]);
    });
  });
}