/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export interface FormStackItemEventCb {
  // 组件内部异常回调
  onError: (errCode?: number, msg?: string) => void;

  // 唯一性标识更新，会触发UI组件上下树
  onUpdateId: (id: string) => void;

  // 卡片点击启动， 记录打点信息
  onClickForm: () => void;

  // 名字更新接口
  onUpdateName: (name: string) => void;

  // 卡片点击事件
  onTouch: (event: TouchEvent) => void;

  // 卡片onLoad回调
  onLoadForm: (id: string) => void;

  // 卡片uninstall回调
  onUninstall: (form: FormCallbackInfo) => void;

  // 获取堆叠父卡id
  getFormStackId: () => string;
}