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

import { SymbolGlyphModifier } from '@kit.ArkUI';
import EditModeConstants from '../../utils/EditModeConstants';
import lazy { EditSearchComponentData, EditSearchComponentParam } from '../viewmodel/EditSearchComponentData';
import { EditSearchComponentEvent } from '../viewmodel/EditSearchComponentEvent';

const EDIT_SEARCH_ID: string = 'outer_app_search';

/**
 * 小折叠外屏应用中心,卡片中心,上方标题栏中的搜索栏组件
 */
@Component
export struct EditSearchComponent {
  @State mData: EditSearchComponentData = new EditSearchComponentData();
  private mEvent: EditSearchComponentEvent = new EditSearchComponentEvent();
  private mSearchComponentParam: EditSearchComponentParam = new EditSearchComponentParam();
  private isForm: boolean = false;

  aboutToAppear(): void {
    this.mData.initData(this.mSearchComponentParam, this.isForm);
    this.mEvent.setData(this.mData);
    this.mData.desktopContext?.eventHub.on(EditModeConstants.CLOSE_KEY_BOARD_OF_OUTER_EDIT_CENTER,
      () => { this.mData.mController.stopEditing(); });
    this.mData.desktopContext?.eventHub.on(EditModeConstants.OUTER_SET_REQUEST_FOCUS, () => {
      focusControl.requestFocus(EDIT_SEARCH_ID);
    });
    this.mData.desktopContext?.eventHub.on(EditModeConstants.OUTER_RESET_SEARCH_DATA, () => {
      this.mData.mSearchValue = '';
      this.mData.resetSearchData();
    });
  }

  aboutToDisappear(): void {
    this.mData.resetSearchData();
    this.mData.desktopContext?.eventHub.off(EditModeConstants.CLOSE_KEY_BOARD_OF_OUTER_EDIT_CENTER);
    this.mData.desktopContext?.eventHub.off(EditModeConstants.OUTER_SET_REQUEST_FOCUS);
    this.mData.desktopContext?.eventHub.off(EditModeConstants.OUTER_RESET_SEARCH_DATA);
  }

  onDidBuild(): void {
    // 第一次进入时设置焦点
    focusControl.requestFocus(EDIT_SEARCH_ID);
  }

  build() {
    RelativeContainer() {
      Search({
        value: this.mData.mSearchValue,
        placeholder: $r('app.string.search'),
        controller: this.mData.mController,
      })
        .id(EDIT_SEARCH_ID)
        .textFont({ size: this.mData.mFontSize })
        .placeholderFont({ size: this.mData.mFontSize })
        .searchIcon(new SymbolGlyphModifier($r('sys.symbol.magnifyingglass')).fontSize(this.mData.mFontSize))
        .cancelButton({ icon: new SymbolGlyphModifier($r('sys.symbol.xmark')).fontSize(this.mData.mFontSize) })
        .borderRadius($r('sys.float.corner_radius_level12'))
        .fontColor($r('sys.color.font_primary'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .draggable(false)
        .defaultFocus(true)
        .offset({ y: EditModeConstants.OUTER_SEARCH_COMPONENT_OFFSET_Y })
        .editMenuOptions({
          onCreateMenu: (menuItems: Array<TextMenuItem>) => {
            // 过滤拍摄输入菜单
            return this.mData.filterMenu(menuItems);
          },
          onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
            return false;
          }
        })
        .onFocus(() => {
          this.mEvent.searchOnFocus();
        })
        .onBlur(() => {
          this.mEvent.searchOnBlur();
        })
        .onSubmit((value) => {
          this.mEvent.searchOnSubmit(value);
        })
        .onChange((value) => {
          this.mEvent.searchOnChange(value);
        })
        .height(EditModeConstants.OUTER_SEARCH_HEIGHT)
    }
    .height('auto')
    .width('100%')
  }
}