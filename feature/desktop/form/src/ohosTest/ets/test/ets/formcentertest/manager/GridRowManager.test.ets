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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType } from '@ohos/hypium';
import GridRowManager from '../../../../../../main/ets/default/manager/GridRowManager';
import FormStyleConstants from '../../../../../../main/ets/default/common/constants/FormStyleConstants';

export function GridRowManagerTest() {
  describe('GridRowManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getColumns', TestType.FUNCTION | Level.LEVEL0 , () => {
      let gridRowManager: GridRowManager = new GridRowManager(FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS,
        FormStyleConstants.FORM_MANAGER_PANEL_GUTTER_DEFAULT, FormStyleConstants.BREAKPOINT_8_COLUMN);
      expect(gridRowManager.getColumns()).assertEqual(FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS);
    });

    it('getGutterX', TestType.FUNCTION | Level.LEVEL0 , () => {
      let gridRowManager: GridRowManager = new GridRowManager(FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS,
        FormStyleConstants.FORM_MANAGER_PANEL_GUTTER_DEFAULT, FormStyleConstants.BREAKPOINT_8_COLUMN);
      expect(gridRowManager.getGutterX()).assertEqual(FormStyleConstants.FORM_MANAGER_PANEL_GUTTER_DEFAULT);
    });

    it('getSingleColumnWidth', TestType.FUNCTION | Level.LEVEL0 , () => {
      let gridRowManager: GridRowManager = new GridRowManager(FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS,
        FormStyleConstants.FORM_MANAGER_PANEL_GUTTER_DEFAULT, FormStyleConstants.BREAKPOINT_8_COLUMN);
      const expectedValue = (FormStyleConstants.BREAKPOINT_8_COLUMN - (FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS - 1) *
        FormStyleConstants.FORM_MANAGER_PANEL_GUTTER_DEFAULT) / FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS;
      expect(gridRowManager.getSingleColumnWidth()).assertEqual(expectedValue);
    });

    it('getSpanWidth1', TestType.FUNCTION | Level.LEVEL0 , () => {
      let gridRowManager: GridRowManager = new GridRowManager(0, 0, 0);
      expect(gridRowManager.getSpanWidth(-1)).assertEqual(0);
    });

    it('getSpanWidth2', TestType.FUNCTION | Level.LEVEL0 , () => {
      let gridRowManager: GridRowManager = new GridRowManager(FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS,
        FormStyleConstants.FORM_MANAGER_PANEL_GUTTER_DEFAULT, FormStyleConstants.BREAKPOINT_8_COLUMN);
      expect(gridRowManager.getSpanWidth(1)).assertEqual(gridRowManager.getSingleColumnWidth());
    });

    it('getSpanWidth3', TestType.FUNCTION | Level.LEVEL0 , () => {
      let gridRowManager: GridRowManager = new GridRowManager(FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS,
        FormStyleConstants.FORM_MANAGER_PANEL_GUTTER_DEFAULT, FormStyleConstants.BREAKPOINT_8_COLUMN);
      const expectedValue: number = gridRowManager.getSingleColumnWidth() * FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS +
              gridRowManager.getGutterX() * (FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS - 1);
      expect(gridRowManager.getSpanWidth(FormStyleConstants.FORM_MANAGER_PANEL_COLUMNS)).assertEqual(expectedValue);
    });
  })
}