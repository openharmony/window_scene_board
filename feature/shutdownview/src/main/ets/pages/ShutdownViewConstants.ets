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

interface ShutdownConstantProps {
  maxAppNumWithoutScroll: number;
  confirmDlgTitleMaxLines: number;
  sessionColor: string;
  sessionColorDark: string;
  cancelButtonId: string;
  isHibernateOpen: string;
  hibernateKey: string;
  virtualMachineKey: string;
  virtualMachineBundleName: string;
  virtualMachineTerminateKey: string;
  virtualMachineCurrentUser: string;
}

export const ShutdownViewConstant: ShutdownConstantProps = {
  maxAppNumWithoutScroll: 3, // 正在关闭的应用弹窗自动缩放时最大应用数量
  confirmDlgTitleMaxLines: 2, // 文本最大行数
  sessionColor: '#33000000', // 弹窗阴影颜色
  sessionColorDark: '#4D000000', // 深色模式弹窗阴影颜色
  cancelButtonId: 'ShutDownDialogCancelButton', // '取消'按钮的id，用于获焦
  isHibernateOpen: '1', //hibernate开关打开时的值
  hibernateKey: 'settings.power.hibernate_flag', //hibernate开关在数据库的key
  virtualMachineKey: 'hwf.shutdown.allowed', //有虚拟机在更新镜像时为false
  virtualMachineBundleName: 'hwf.bundle.name', //虚拟机的bundleName
  virtualMachineTerminateKey: 'hwf.terminate.flag', // 虚拟机更新镜像时关机跳转到虚拟机界面
  virtualMachineCurrentUser: 'hwf.current.user' // 虚拟机进程所在账户
}
