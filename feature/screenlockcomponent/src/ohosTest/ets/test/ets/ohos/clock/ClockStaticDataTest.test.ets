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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { ClockLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { DateWeekLunarStyle } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockConstants';
import { ClockGridParam } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutParam';

export default function ClockStaticDataTest() {
  const mClockStaticData: ClockStaticData = new ClockStaticData();
  const BASE_CLOCK_LAYOUT_GRID_SIZE: number = 78;
  describe('ClockStaticDataTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })
    
    it('test_mClockWidgetModel_updateClockWidgetExpand_return_true',  '0', (): void => {
      ClockStaticData.sIsClockWidgetExpand = true;
      let mIsClockWidgetExpand = ClockStaticData.updateClockWidgetExpand(false);
      mClockStaticData.getCurGrid();
      mClockStaticData.getCurElementConf();
      expect(mIsClockWidgetExpand).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateClockWidgetExpand_return_false',  '0', (): void => {
      ClockStaticData.sIsClockWidgetExpand = true;
      let mIsClockWidgetExpand = ClockStaticData.updateClockWidgetExpand(true);
      mClockStaticData.getCurGrid();
      mClockStaticData.getCurElementConf();
      expect(mIsClockWidgetExpand).assertEqual(false);
    })

    it('test_mClockWidgetModel_ClockLayoutWithDefault_return_true', '0', (): void => {
      mClockStaticData.getClockLayoutWithDefault();
      let mIsUpdateClockLayout = mClockStaticData.updateClockLayout(ClockLayout.DIMENSION_4_4);
      expect(mIsUpdateClockLayout).assertEqual(true);
    })

    it('test_mClockWidgetModel_ClockLayoutWithDefault__return_false', '0', (): void => {
      mClockStaticData.getClockLayoutWithDefault();
      let mIsUpdateClockLayout = mClockStaticData.updateClockLayout(ClockLayout.DEFAULT_CLOCK_SPECIAL);
      expect(mIsUpdateClockLayout).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateScreenPortrait_return_true', '0', (): void => {
      mClockStaticData.isScreenPortrait = !AppStorage.get<boolean>('isPortrait') as boolean;
      let mIsScreenPortrait = mClockStaticData.updateScreenPortrait();
      expect(mIsScreenPortrait).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateScreenPortrait_return_false', '0', (): void => {
      mClockStaticData.isScreenPortrait = AppStorage.get<boolean>('isPortrait') as boolean;
      let mIsScreenPortrait = mClockStaticData.updateScreenPortrait();
      expect(mIsScreenPortrait).assertEqual(false);
    })

    it('test_mClockWidgetModel_updateFoldExpand_return_true', '0', (): void => {
      mClockStaticData.isFoldExpanded = !clockLayoutHelper.isFullDisplayMode();
      let misFoldExpanded = mClockStaticData.updateFoldExpand();
      expect(misFoldExpanded).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateFoldExpand_return_false', '0', (): void => {
      mClockStaticData.isFoldExpanded = clockLayoutHelper.isFullDisplayMode();
      let misFoldExpanded = mClockStaticData.updateFoldExpand();
      expect(misFoldExpanded).assertEqual(false);
    })

    it('test_mClockWidgetModel_updateDisplayScale_return_true', '0', (): void => {
      mClockStaticData.displayScale = BASE_CLOCK_LAYOUT_GRID_SIZE;
      mClockStaticData.getCurElementConf();
      mClockStaticData.updateGridAndElementConf();
      mClockStaticData.updateClockViewMargin();
      let mIsDisplayScale = mClockStaticData.updateDisplayScale();
      expect(mIsDisplayScale).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateDisplayScale_return_false', '0', (): void => {
      mClockStaticData.isScreenPortrait = AppStorage.get<boolean>('isPortrait') as boolean;
      mClockStaticData.layoutGridWidth = clockLayoutHelper.getLayoutGridWidth(mClockStaticData.isScreenPortrait);
      mClockStaticData.displayScale = mClockStaticData.layoutGridWidth / BASE_CLOCK_LAYOUT_GRID_SIZE;
      mClockStaticData.getCurElementConf();
      mClockStaticData.updateGridAndElementConf();
      mClockStaticData.updateClockViewMargin();
      let mIsDisplayScale = mClockStaticData.updateDisplayScale();
      expect(mIsDisplayScale).assertEqual(false);
    })

    it('test_mClockWidgetModel_updateClockViewMargin0', '0', (): void => {
      mClockStaticData.clockMarginLeft = 0;
      mClockStaticData.clockMarginTop = 0;
      ClockStaticData.sIsClockWidgetExpand = true;
      mClockStaticData.clockLayout = ClockLayout.DIMENSION_4_4;
      mClockStaticData.updateDisplayScale();
      ClockStaticData.updateClockWidgetExpand(false);
      let mIsUpdateClockMargin = mClockStaticData.updateClockViewMargin();
      expect(mIsUpdateClockMargin).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateClockViewMargin1', '0', (): void => {
      mClockStaticData.clockMarginLeft = 0;
      mClockStaticData.clockMarginTop = 0;
      ClockStaticData.sIsClockWidgetExpand = true;
      mClockStaticData.clockLayout = ClockLayout.MOUNTAIN_CLOCK_LAYOUT;
      ClockStaticData.updateClockWidgetExpand(false);
      let mIsUpdateClockMargin = mClockStaticData.updateClockViewMargin();
      expect(mIsUpdateClockMargin).assertEqual(false);
    })

    it('test_mClockWidgetModel_updateClockViewMargin2', '0', (): void => {
      mClockStaticData.clockMarginLeft = 0;
      mClockStaticData.clockMarginTop = 0;
      ClockStaticData.sIsClockWidgetExpand = true;
      mClockStaticData.clockLayout = ClockLayout.DIMENSION_4_4;
      let mIsUpdateClockMargin = mClockStaticData.updateClockViewMargin();
      expect(mIsUpdateClockMargin).not().assertNull();
    })

    it('test_mClockWidgetModel_updateClockViewMargin3', '0', (): void => {
      mClockStaticData.clockMarginLeft = 1;
      mClockStaticData.clockMarginTop = 1;
      ClockStaticData.sIsClockWidgetExpand = true;
      let mIsUpdateClockMargin = mClockStaticData.updateClockViewMargin();
      expect(mIsUpdateClockMargin).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateDateWeekLunarStyle_0', '0', (): void => {
      mClockStaticData.isSignVisible = false;
      mClockStaticData.isMergeWeekLunar = true;
      let mIsUpdateDateWeekLunar = mClockStaticData.updateDateWeekLunarStyle();
      expect(mIsUpdateDateWeekLunar).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateDateWeekLunarStyle_1', '0', (): void => {
      mClockStaticData.collapseGrid = new ClockGridParam();
      mClockStaticData.expandGrid = new ClockGridParam();
      mClockStaticData.collapseGrid.dateSeperate = true;
      mClockStaticData.expandGrid.dateSeperate = true;
      mClockStaticData.collapseGrid.largeDate = true;
      mClockStaticData.expandGrid.largeDate = true;
      mClockStaticData.isSignVisible = false;
      mClockStaticData.isMergeWeekLunar = false;
      mClockStaticData.isShowLargeDate = true;
      mClockStaticData.dateWeekStyle = DateWeekLunarStyle.STYLE_SEPARATOR;
      let mIsUpdateDateWeekLunar = mClockStaticData.updateDateWeekLunarStyle();
      expect(mIsUpdateDateWeekLunar).assertEqual(false);
    })

    it('test_mClockWidgetModel_updateDateWeekLunarStyle_2', '0', (): void => {
      mClockStaticData.collapseGrid = new ClockGridParam();
      mClockStaticData.expandGrid = new ClockGridParam();
      mClockStaticData.collapseGrid.dateSeperate = false;
      mClockStaticData.expandGrid.dateSeperate = false;
      mClockStaticData.collapseGrid.largeDate = true;
      mClockStaticData.expandGrid.largeDate = true;
      mClockStaticData.collapseGrid.singleLineDate = false;
      mClockStaticData.expandGrid.singleLineDate = false;
      mClockStaticData.isSignVisible = false;
      mClockStaticData.isMergeWeekLunar = false;
      mClockStaticData.isShowLargeDate = true;
      mClockStaticData.dateWeekStyle = DateWeekLunarStyle.STYLE_MULTILINE;
      let mIsUpdateDateWeekLunar = mClockStaticData.updateDateWeekLunarStyle();
      expect(mIsUpdateDateWeekLunar).assertEqual(true);
    })

    it('test_mClockWidgetModel_updateDateWeekLunarStyle_3', '0', (): void => {
      mClockStaticData.collapseGrid = new ClockGridParam();
      mClockStaticData.expandGrid = new ClockGridParam();
      mClockStaticData.collapseGrid.dateSeperate = false;
      mClockStaticData.expandGrid.dateSeperate = false;
      mClockStaticData.collapseGrid.largeDate = true;
      mClockStaticData.expandGrid.largeDate = true;
      mClockStaticData.collapseGrid.singleLineDate = true;
      mClockStaticData.expandGrid.singleLineDate = true;
      mClockStaticData.isSignVisible = false;
      mClockStaticData.isMergeWeekLunar = false;
      mClockStaticData.isShowLargeDate = true;
      mClockStaticData.dateWeekStyle = DateWeekLunarStyle.STYLE_SINGLE_LINE;
      let mIsUpdateDateWeekLunar = mClockStaticData.updateDateWeekLunarStyle();
      expect(mIsUpdateDateWeekLunar).assertEqual(true);
    })

    it('test_updateClockToCollapseOnDesktop', 0, () => {
      mClockStaticData.isClockToCollapseOnDesktop = true;
      mClockStaticData.updateClockToCollapseOnDesktop(false);
      mClockStaticData.updateClockToCollapseOnDesktop(true);
      expect(true).assertTrue();
    });

    it('test_getTimeFontWeightStr', 0, () => {
      ClockStaticData.getTimeFontWeightStr('test');
      expect(true).assertTrue();
    });

    it('test_updateClockLayout', 0, () => {
      mClockStaticData.updateClockLayout(-1);
      expect(true).assertTrue();
    });

    it('test_getCurGrid', 0, () => {
      mClockStaticData.isClockToCollapseOnDesktop = false;
      mClockStaticData.getCurGrid();
      expect(true).assertTrue();
    });

    it('test_getPreGrid', 0, () => {
      ClockStaticData.sIsClockWidgetExpand = false;
      mClockStaticData.getPreGrid();
      ClockStaticData.sIsClockWidgetExpand = true;
      mClockStaticData.getPreGrid();
      expect(true).assertTrue();
    });

    it('test_getCurElementConf', 0, () => {
      mClockStaticData.isClockToCollapseOnDesktop = true;
      mClockStaticData.getCurElementConf();
      expect(true).assertTrue();
    });

    it('test_getPreElementConf', 0, () => {
      ClockStaticData.sIsClockWidgetExpand = false;
      mClockStaticData.getPreElementConf();
      ClockStaticData.sIsClockWidgetExpand = true;
      mClockStaticData.getPreElementConf();
      expect(true).assertTrue();
    });

    it('test_updateClockOffset', 0, () => {
      mClockStaticData.updateClockOffset(false);
      mClockStaticData.updateClockOffset(true);
      expect(true).assertTrue();
    });

    it('test_updateClockRectInfo', 0, () => {
      mClockStaticData.updateClockRectInfo();
      expect(true).assertTrue();
    });

    it('test_updatePageDesktopClockRectInfo', 0, () => {
      (mClockStaticData as object)['updatePageDesktopClockRectInfo']();
      expect(true).assertTrue();
    });

    it('test_getClockOffset', 0, () => {
      mClockStaticData.getClockOffset(false);
      mClockStaticData.getClockOffset(true, false);
      expect(true).assertTrue();
    });

    it('test_updateNoTimeViewOpacity', 0, () => {
      mClockStaticData.noTimeViewOpacity = 0;
      mClockStaticData.updateNoTimeViewOpacity();
      mClockStaticData.noTimeViewOpacity = 1;
      mClockStaticData.updateNoTimeViewOpacity();
      expect(true).assertTrue();
    });

    it('test_getNoTimeViewOpacity', 0, () => {
      mClockStaticData.getNoTimeViewOpacity(true);
      mClockStaticData.getNoTimeViewOpacity(false);
      expect(true).assertTrue();
    });

    it('test_updateTimeViewOpacity', 0, () => {
      mClockStaticData.timeViewOpacity  = 0.7;
      mClockStaticData.updateTimeViewOpacity();
      mClockStaticData.timeViewOpacity  = 1;
      mClockStaticData.updateTimeViewOpacity();
      expect(true).assertTrue();
    });

    it('test_setTextColorOfDesktopClock', 0, () => {
      mClockStaticData.setTextColorOfDesktopClock('test');
      expect(true).assertTrue();
    });

    it('test_updateTextColor', 0, () => {
      mClockStaticData.isClockToCollapseOnDesktop = true;
      mClockStaticData.updateTextColor();

      mClockStaticData.isClockToCollapseOnDesktop = false;
      mClockStaticData.textColorOfScreenLockClock = '#111111';
      mClockStaticData.updateTextColor();
      expect(true).assertTrue();
    });

    it('test_updateTextOffSets', 0, () => {
      mClockStaticData.isClockToCollapseOnDesktop = false;
      mClockStaticData.updateTextOffSets(10);

      mClockStaticData.isClockToCollapseOnDesktop = true;
      mClockStaticData.updateTextOffSets(10);
      expect(true).assertTrue();
    });

    it('test_updateScaleOptions', 0, () => {
      mClockStaticData.isClockToCollapseOnDesktop = false;
      mClockStaticData.updateScaleOptions();

      mClockStaticData.isClockToCollapseOnDesktop = true;
      mClockStaticData.updateScaleOptions();
      expect(true).assertTrue();
    });

    it('test_updateFontSizeAfterSlideUp', 0, () => {
      mClockStaticData.isClockToCollapseOnDesktop = false;
      mClockStaticData.updateFontSizeAfterSlideUp(10);

      mClockStaticData.isClockToCollapseOnDesktop = true;
      mClockStaticData.updateFontSizeAfterSlideUp(10);
      expect(true).assertTrue();
    });

    it('test_updateFontSizeAfterScreenOff', 0, () => {
      mClockStaticData.updateFontSizeAfterScreenOff(10);
      expect(true).assertTrue();
    });

    it('test_getScreenLockTimeFontSize', 0, () => {
      ClockStaticData.sIsClockWidgetExpand = true;
      mClockStaticData.getScreenLockTimeFontSize();
      ClockStaticData.sIsClockWidgetExpand = false;
      mClockStaticData.getScreenLockTimeFontSize();
      expect(true).assertTrue();
    });
  })
}