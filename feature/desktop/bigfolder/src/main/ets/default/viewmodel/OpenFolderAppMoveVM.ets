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

/**
 * 文件夹展开态挤位补位动效Vm
 *
 */
@Observed
export class OpenFolderAppMoveVm {
  // 偏移量状态变量绑定
  @Track public translateX: number = 0;
  @Track public translateY: number = 0;
  // 动效终点目标偏移量
  public targetTranslateX: number = 0;
  public targetTranslateY: number = 0;
  // 对应节点Id
  public id: string = '';
}