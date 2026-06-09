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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  ControlCenterComponentStyle,
  ControlCenterHeaderStyle,
  ControlCenterMediaCardLayoutStyle,
  ControlCenterQuickToggleLayoutStyle,
  QuickToggleLayoutEditComponentStyle
} from '../../../../../../main/ets/com/ohos/common/StyleConfiguration';
import StyleConfiguration from '../../../../../../main/ets/com/ohos/common/StyleConfiguration';

export function StyleConfigurationTest() {
  describe('StyleConfigurationTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('StyleConfigurationTest001', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let panelPadding = value.panelPadding
      expect(panelPadding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest002', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let panelWidth = value.panelWidth
      expect(panelWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest003', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let panelListSpace = value.panelListSpace
      expect(panelListSpace).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest004', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let bottomSpace = value.bottomSpace
      expect(bottomSpace).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest005', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let bottomSpaceLand = value.bottomSpaceLand
      expect(bottomSpaceLand).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest006', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let marginBottom = value.marginBottom
      expect(marginBottom).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest007', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let listMargin = value.listMargin
      expect(listMargin).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest008', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let borderRadius = value.borderRadius
      expect(borderRadius).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest009', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let bottomBankHeight = value.bottomBankHeight
      expect(bottomBankHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest010', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let quickToggleTopMargin = value.quickToggleTopMargin
      expect(quickToggleTopMargin).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest011', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let labelColorType1: string = value.labelColorType1
      expect(labelColorType1).assertInstanceOf('String');
    })

    it('StyleConfigurationTest012', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let labelColorType2: string = value.labelColorType2
      expect(labelColorType2).assertInstanceOf('String');
    })

    it('StyleConfigurationTest013', 0, (): void => {
      let value = new ControlCenterComponentStyle()
      let labelColorType3: string = value.labelColorType3
      expect(labelColorType3).assertInstanceOf('String');
    })

    it('StyleConfigurationTest014', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let headerHeight = value.headerHeight
      expect(headerHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest015', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let headerHeightLand = value.headerHeightLand
      expect(headerHeightLand).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest016', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let paddingLeft = value.paddingLeft
      expect(paddingLeft).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest017', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let paddingBottom = value.paddingBottom
      expect(paddingBottom).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest018', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let tittleMarginBottom = value.tittleMarginBottom
      expect(tittleMarginBottom).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest019', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let fontSize = value.fontSize
      expect(fontSize).assertInstanceOf('Number');
    })


    it('StyleConfigurationTest021', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let buttonSize = value.buttonSize
      expect(buttonSize).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest022', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let buttonPadding = value.buttonPadding
      expect(buttonPadding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest023', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let buttonDiameter = value.buttonDiameter
      expect(buttonDiameter).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest024', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let iconPadding = value.iconPadding
      expect(iconPadding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest025', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let headerWidth = value.headerWidth
      expect(headerWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest026', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let brightness = value.brightness
      expect(brightness).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest027', 0, (): void => {
      let value = new ControlCenterHeaderStyle()
      let landscapeWidth = value.landscapeWidth
      expect(landscapeWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest028', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let cardWidth = value.cardWidth
      expect(cardWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest029', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let cardHeight = value.cardHeight
      expect(cardHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest030', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let cardLandscapeWidth = value.cardLandscapeWidth
      expect(cardLandscapeWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest031', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let cardHeightWithoutMedia = value.cardHeightWithoutMedia
      expect(cardHeightWithoutMedia).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest032', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let cardGap = value.cardGap
      expect(cardGap).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest033', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let cardMargin = value.cardMargin
      expect(cardMargin).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest034', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let borderRadius = value.borderRadius
      expect(borderRadius).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest035', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let space = value.space
      expect(space).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest036', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let newCardWidth = value.newCardWidth
      expect(newCardWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest037', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let newCardHeight = value.newCardHeight
      expect(newCardHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest038', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let newBorderRadius = value.newBorderRadius
      expect(newBorderRadius).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest039', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let brightness = value.brightness
      expect(brightness).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest040', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let landscapeWidth = value.landscapeWidth
      expect(landscapeWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest041', 0, (): void => {
      let value = new ControlCenterMediaCardLayoutStyle()
      let mediaLandscapeWidth = value.mediaLandscapeWidth
      expect(mediaLandscapeWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest042', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let toggleLabelHeight = value.toggleLabelHeight
      expect(toggleLabelHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest043', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let padding = value.padding
      expect(padding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest044', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let paddingBottom = value.paddingBottom
      expect(paddingBottom).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest045', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let columnGap = value.columnGap
      expect(columnGap).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest046', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let cellHeight = value.cellHeight
      expect(cellHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest047', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let borderRadius = value.borderRadius
      expect(borderRadius).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest048', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let togglePanelHeight = value.togglePanelHeight
      expect(togglePanelHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest049', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let brightnessWidth = value.brightnessWidth
      expect(brightnessWidth).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest050', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let brightnessPadding = value.brightnessPadding
      expect(brightnessPadding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest051', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let defaultBrightness = value.defaultBrightness
      expect(defaultBrightness).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest052', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let onBrightness = value.onBrightness
      expect(onBrightness).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest053', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let buttonDiameter = value.buttonDiameter
      expect(buttonDiameter).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest054', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let pluginPadding = value.pluginPadding
      expect(pluginPadding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest055', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let buttonMarginBottom = value.buttonMarginBottom
      expect(buttonMarginBottom).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest056', 0, (): void => {
      let value = new ControlCenterQuickToggleLayoutStyle()
      let buttonLabelHeight = value.buttonLabelHeight
      expect(buttonLabelHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest057', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let padding = value.padding
      expect(padding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest058', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let toggleLabelHeight = value.toggleLabelHeight
      expect(toggleLabelHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest059', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let titleHeight = value.titleHeight
      expect(titleHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest060', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let titleHeightLand = value.titleHeightLand
      expect(titleHeightLand).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest061', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let titleFontSize = value.titleFontSize
      expect(titleFontSize).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest061', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let titleMarginLeft = value.titleMarginLeft
      expect(titleMarginLeft).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest062', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let titleMarginBottom = value.titleMarginBottom
      expect(titleMarginBottom).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest063', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let buttonSize = value.buttonSize
      expect(buttonSize).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest064', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let buttonPadding = value.buttonPadding
      expect(buttonPadding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest065', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let paddingBottom = value.paddingBottom
      expect(paddingBottom).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest066', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let borderRadius = value.borderRadius
      expect(borderRadius).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest067', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let cellHeight = value.cellHeight
      expect(cellHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest068', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let columnGap = value.columnGap
      expect(columnGap).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest069', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let dragBgSize = value.dragBgSize
      expect(dragBgSize).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest070', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let fontSize = value.fontSize
      expect(fontSize).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest071', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let height = value.height
      expect(height).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest072', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let msgPaddingTop = value.msgPaddingTop
      expect(msgPaddingTop).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest073', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let msgPaddingBottom = value.msgPaddingBottom
      expect(msgPaddingBottom).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest074', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let msgPadding = value.msgPadding
      expect(msgPadding).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest075', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let editBtnHeight = value.editBtnHeight
      expect(editBtnHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest076', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let editAreaHeight = value.editAreaHeight
      expect(editAreaHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest077', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let editBtnPadding = value.editBtnPadding
      expect(editBtnPadding).assertInstanceOf('Number');
    })

    it('AccountMenuItem001', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem002', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem003', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem004', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem005', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem006', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem007', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem008', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem009', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem010', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem011', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem012', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem013', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem014', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem015', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem016', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem017', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem018', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem019', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem020', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem021', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem022', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem023', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem024', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem025', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem026', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem027', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem028', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem029', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem030', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem031', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem032', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem033', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem034', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem035', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem036', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem037', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem038', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem039', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem040', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem041', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem042', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem043', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem044', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem045', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem046', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem047', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem048', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem049', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem050', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem051', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem052', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem053', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem054', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem055', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem056', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem057', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem058', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem059', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem060', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem061', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem062', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem063', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem064', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem001', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem002', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem003', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem004', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem005', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem006', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem007', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem008', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem009', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem010', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem011', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem012', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem013', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem014', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem015', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem016', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem017', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem018', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem019', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem020', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem021', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem022', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem023', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem024', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem025', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem026', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem027', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem028', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem029', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem030', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem031', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem032', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem033', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem034', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem035', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem036', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem037', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem038', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem039', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem040', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem041', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem042', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem043', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem044', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem045', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem046', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem047', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem048', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem049', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem050', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem051', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem052', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem053', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem054', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem055', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem056', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem057', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem058', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem059', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem060', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem061', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem062', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem063', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem064', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem065', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem066', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem067', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem068', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem069', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem070', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem071', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem072', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem073', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem074', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem075', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem076', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem077', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem078', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem079', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem080', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem081', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem082', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem083', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem084', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem085', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem086', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem087', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem088', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem089', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem090', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('CommonToggleControllerTest001', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest002', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest003', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest004', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest005', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest006', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest007', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest008', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest009', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest019', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })
  })
}