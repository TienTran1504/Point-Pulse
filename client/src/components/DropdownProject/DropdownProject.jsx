import { useEffect } from 'react';
import classes from './styles.module.scss';
import { Checkbox } from '@mui/material';
const sx = { '& .MuiSvgIcon-root': { fontSize: 18, color: '#6faf8c' } };

export default function DropdownProject(props) {
  const { setSelectedProjects, selectedProjects, projectData } = props
  useEffect(() => {
    checkedAll();
  }, [selectedProjects])
  const handleSelected = (project) => (e) => {
    if (e.target.checked) {
      setSelectedProjects((prevSelectedProjects) => {
        const newSelectedProjects = [...prevSelectedProjects, project];
        return sortSelectedProjectsById(newSelectedProjects);
      });
    } else {
      setSelectedProjects((prevSelectedProjects) => {
        const newSelectedProjects = prevSelectedProjects.filter(
          (selectedProject) => selectedProject.id !== project.id
        );
        return sortSelectedProjectsById(newSelectedProjects);
      });
    }
  };

  const handleSelectedAll = () => (e) => {
    if (e.target.checked) {
      setSelectedProjects(projectData);
    } else {
      setSelectedProjects([]);
    }
  };
  const checkedSelected = (project) => {
    const checked = selectedProjects.some((selected) => selected.id === project.id)
    return checked;
  }
  const sortSelectedProjectsById = (projects) => {
    return projects.slice().sort((a, b) => a.id - b.id);
  };
  const checkedAll = () => {
    return selectedProjects.length === projectData.length
  }
  return (
    <div className={classes.main_container}>
      <div className={classes.title}>
        Filter Projects
        <div className={classes.checkbox}>
          <Checkbox
            checked={checkedAll()}
            className={classes.checkbox__ic}
            sx={sx}
            onChange={handleSelectedAll()}
          />
        </div>

      </div>

      <div className={classes.filterItem}>
        {projectData.map((project) => (
          <div key={project.id} className={classes.checkbox}>
            <Checkbox
              checked={checkedSelected(project)}
              className={classes.checkbox__ic}
              sx={sx}
              onChange={handleSelected(project)}
            />
            <div className={classes.checkbox__label}>{project.name}</div>
          </div>
        ))}
      </div>
    </div>
  );
}