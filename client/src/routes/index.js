import Home from '~/pages/Home/Home';
import LoginPage from '~/pages/Login/Login';
import NewPage from '~/pages/NewPage/NewPage';
import ViewReportPage from '~/pages/ViewReport/ViewReport';

import UserManagementPage from '~/pages/UserManagement/UserManagement';
import ProjectPointManagementPage from '~/pages/ProjectPointManagement/ProjectPointManagement';
import ProjectUserPage from '~/pages/ProjectManagement/ProjectUser/ProjectUser';
import ProjectManagementPage from '~/pages/ProjectManagement/ProjectManagement';
import PointManagementPage from '~/pages/PointManagement/PointManagement';
import MasterDataManagementPage from '~/pages/MasterDataManagement/MasterDataManagement';
import ProjectTypePage from '~/pages/MasterDataManagement/ProjectType/ProjectType';
import UserRolePage from '~/pages/MasterDataManagement/UserRole/UserRole';
import UserWorkPointPage from '~/pages/UserManagement/UserWorkPoint/UserWorkPoint'
import ManagingPage from '~/pages/PointManagement/Managing/Managing'
import PersonalPage from '~/pages/PointManagement/Personal/Personal'


const SetUpRoutes = [
    { path: '/home', component: Home },
    { path: '/', component: LoginPage },
    { path: '/report', component: ViewReportPage },
    { path: '/user_management', component: UserManagementPage },
    { path: '/user_management/user_work_point', component: UserWorkPointPage },
    { path: '/project_point_management', component: ProjectPointManagementPage },
    { path: '/project_management', component: ProjectManagementPage },
    { path: '/project_management/project_user/:project_id', component: ProjectUserPage },
    { path: '/point_management', component: PointManagementPage },
    { path: '/point_management/managing', component: ManagingPage },
    { path: '/point_management/personal', component: PersonalPage },
    { path: '/master_data_management', component: MasterDataManagementPage },
    { path: '/master_data_management/project_type', component: ProjectTypePage },
    { path: '/master_data_management/user_role', component: UserRolePage },
    { path: '/newpage', component: NewPage },

]



export { SetUpRoutes }