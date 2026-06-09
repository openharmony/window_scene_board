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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Curves from '@ohos.curves'
import { CardItemInfo, FormCommonUtil } from '../TsIndex';

const TAG = 'FormIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export default struct FormIcon {
  @State iconScale: number = 1;
  @State iconOpacity: number = 1;
  @Prop isAllowUpdate: boolean;
  @Prop isShow: boolean;
  private formItem: CardItemInfo = new CardItemInfo();
  private formItemWidth: number = 0;
  private formItemHeight: number = 0;
  private formId: string = '';
  getFormId?: (id: string) => void;
  clickForm?: Function;

  // 子组件向父组件传formId
  private transferFormId?: (formId: string) => void;

  // 动画参数
  @State animateParam: AnimateParam = {
    duration: 200, // 动画时长
    tempo: 1, // 动画播放速度
    curve: Curves.springCurve(0.5, 1, 350, 35), // 动画曲线
    delay: 0, // 动画延迟执行的时长
    iterations: 1, // 播放次数
    playMode: PlayMode.Normal, // 动画播放模式
  };

  build() {
    Column() {
      FormComponent({
        id: FormCommonUtil.transformCardId(this.formItem.cardId),
        name: this.formItem.cardName,
        bundle: this.formItem.bundleName,
        ability: this.formItem.abilityName,
        module: this.formItem.moduleName,
        dimension: this.formItem.cardDimension
      })
        .id(`${TAG}_FormComponent_${this.formItem.bundleName}`)
        .hoverEffect(HoverEffect.None)
        .clip(new Rect({ width: this.formItemWidth, height: this.formItemHeight, radius: 24 }))
        .size({ width: this.formItemWidth, height: this.formItemHeight })
        .allowUpdate(this.isAllowUpdate)
        .visibility(this.isShow ? Visibility.Visible : Visibility.None)
        .onAcquired((form: FormCallbackInfo) => {
          log.showInfo(`FormComponent card id angus is: ${form.idString}`);
          this.formId = String(form.idString);
          if (this.transferFormId) {
            this.transferFormId(String(this.formId));
          }
          if (this.getFormId) {
            this.getFormId(String(form.idString));
          }
        })
        .onError((error) => {
          log.showInfo(`FormComponent error msg: ${error.msg}`);
        })
    }.id(`${TAG}_column_parent`)
    .onClick((event: ClickEvent) => {
      log.showInfo(`FormComponent onClick`);
      if (this.clickForm) {
        this.clickForm(event, this.formItem);
      }
    })

    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.iconScale = 0.9;
      } else if (event.type === TouchType.Up) {
        this.iconScale = 1;
      }
    })
    .scale({ x: this.iconScale, y: this.iconScale })
    .opacity(this.iconOpacity)
    .animation(this.animateParam)
  }
}